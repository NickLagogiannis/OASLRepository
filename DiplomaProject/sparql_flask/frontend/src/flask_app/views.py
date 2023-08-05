import os
from time import sleep
from sys import stderr
import subprocess as sp
from pprint import pprint
import logging
import time
import math

from werkzeug.utils import secure_filename
from flask import Response, render_template, request, make_response, redirect
import gzip
import xmltodict
import requests

from . import app, jar_executor, jar_translator

#This query is displyed the first time who someone enters in Execution Page.

a_query = """
SELECT ?serviceTitle
WHERE { 
Service title ?serviceTitle .
Request method GET .

}

    """

#--------------------------------------------------#

get_query = """
SELECT  DISTINCT ?g 
WHERE  { GRAPH ?g { ?s ?p ?o} } 
ORDER BY  ?g
"""
#--------------------------------------------------#

virt_path = 'http://virtuoso_box:8890/sparql'

virt_base_file_path = 'http://example.com/'
  
upload_dir = "./uploads"
os.makedirs(upload_dir, exist_ok=True)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ['py']


def dm(*args):
    print("==>", *args, file=stderr)
    return

def dm_pp(arg, **kwargs):
    dm("Pretty print:")
    pprint(arg, stream=stderr, **kwargs)
    return


def upload_file_to_virtuoso(file_path: str, file_name: str):
    p = sp.Popen(['curl', '--digest', '--user', 'dba:dba',
                  '--url', f'http://virtuoso_box:8890/sparql-graph-crud-auth?graph-uri={virt_base_file_path}{file_name}',
                  '-T', file_path], stdout=sp.PIPE, stderr=sp.PIPE)
    sout, serr = p.communicate()
    dm(f"File detected: {file_name}")
    dm(f"sout:\n{sout}")
    dm(f"serr:\n{serr}")
    return


# @app.route('/test5')
def check_files_init():
    # ==> Get files from virtuoso
    
    # Query virtuoso for the graphs and translate the response into a dict
    for _ in range(100):
        try:
            response = requests.get(virt_path, params={'query': get_query})
            resp_dict = xmltodict.parse(response.text)
        except Exception as ex:
            dm(ex)
            sleep(0.1)
        else:
            break
    else:
        dm("Retrieving data from virtuoso failed every time, exiting.")
        exit(1)
    
    try:
        # Get the list of bindings
        virt_results = resp_dict['sparql']['results']['result']
    except Exception as e:
        dm(e)
        dm('Could not decipher the results from virtuoso; initialization complete with no initial files.')
        return
    else:
        # For each binding get the uri
        virt_graphs: list[str] = list()
        for virt_res in virt_results:
            try:
                virt_graphs.append(virt_res['binding']['uri'])
            except Exception as e:
                dm(e)
                pass
            pass
        pass
    

    
    # Get the files names of the files aready uploaded
    already_uploaded_virt_dirs = set(filter(lambda x: not not x, 
                                            (v.replace(virt_base_file_path, '') 
                                             if v.startswith(virt_base_file_path) else None 
                                             for v in virt_graphs)))
    # dm_pp(already_uploaded_virt_dirs)
    
    # ==> Get the files from the upload directory (files aready uploaded but not 
    # necessarily uploaded to virtuoso as well).
    files = [(fname, os.path.join(upload_dir, fname)) for fname in filter(lambda x: os.path.isfile(os.path.join(upload_dir, x)), os.listdir(upload_dir))]
    # dm_pp(files)
    
    # ==> Upload files not on virtuoso
    
    # Check each file in the folder if it exists in virtuoso and if not upload it/
    for file_name, file_path in files:
        if file_name in already_uploaded_virt_dirs:
            # dm(f'Skipping file: {file_name}')
            continue
        # dm(f'Not skipping file: {file_name}')
        upload_file_to_virtuoso(file_path, file_name)
    
    return "Done"


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/upload', methods=['GET', 'POST'])
def upload():
    # Stores uploaded both locally and in virtuoso.
    message = None
    if request.method == 'POST':
  
        
        for f in request.files.getlist("files[]"):
            if f:
                file_name = secure_filename(f.filename)
                file_name = os.path.splitext(file_name)[0]
                file_path = os.path.join(upload_dir, file_name)
                
                f.save(file_path)
                upload_file_to_virtuoso(file_path, file_name)
                message="Upload complete"
        
    file_list = os.listdir(upload_dir)
    return render_template('upload.html', message=message, file_list=file_list)



@app.route('/execute',  methods=['GET', 'POST'])
def execute():
    
    dm(request.method, request.form)
    rout = [""]
    erout = [""]
    default_query=a_query
    table_headers=[]
    table_body=[]
    show_timings = False
    time_translate = None
    time_query = None
    time_all = None
    
    time_translate_inner = None
    
    time_all_start = time.perf_counter_ns()
    
    if request.method == 'POST':
        query = request.form.get('query_box')
        dm(query)
        
        # Comment to remove timings
        # show_timings = True
        
        
        # Executes the translator jar with the query as input.

        p = sp.Popen(["java", "-jar", jar_translator, query], stdout=sp.PIPE, stderr=sp.PIPE)
        # P = sp.Popen(["java", "-jar", jar_translator, query], stdout=sp.PIPE, stderr=sp.PIPE)
        # result = subprocess.run(['java', '-jar', jar_translator, query], capture_output=True, text=True)
        #     return f"Java Output: {result.stdout}"
        
        time_translate_start = time.perftime_all_start = time.perf_counter_ns()
        sout, serr = p.communicate(input=query)
        time_translate = time.perftime_all_start = time.perf_counter_ns() - time_translate_start
    
        uout, uerr = sout.decode('utf-8'), serr.decode('utf-8')
        
        try:
            time_translate_inner = round(int(uerr) / 1_000_000)
        except Exception:
            pass
        
        
        # virt_path = 'http://127.0.0.1:5000/sparql'
        # dm(f'type uout: {type(uout)}')
        dm("------------------------------- \n")
        dm("------------------------------- \n")
        dm("__________________________________\n")
        dm(uerr)
        dm("___________________________________ \n")
        dm("------------------------------- \n")
        dm("------------------------------- \n")
        try:
            time_query_start = time.perftime_all_start = time.perf_counter_ns()
            response = requests.get(virt_path, params={'query': uout})
            time_query = time.perftime_all_start = time.perf_counter_ns() - time_query_start
        except Exception as ex:
            erout=['Could not communicate with virtuoso']
        else:
            try:
                dm("------------------------------- \n")
                dm(response.text)
                dm("------------------------------- \n")
                resp_dict = xmltodict.parse(response.text)
                dm_pp(resp_dict, width=160)
                
                sparql_table_headers = resp_dict['sparql']['head']['variable']
                if type(sparql_table_headers) == list:
                    table_headers = ['#'] + [item['@name'] for item in sparql_table_headers]
                else:
                    table_headers = ['#', sparql_table_headers['@name']]
                
                headers_lookup = {name: pos for pos, name in enumerate(table_headers)}
                num_headers = len(table_headers)
                table_body_results_dict = resp_dict['sparql']['results']['result']
                dm_pp(table_body_results_dict)
                table_body = []
                if type(table_body_results_dict) == dict:
                    table_body_results_dict = [table_body_results_dict]
                for i, result in enumerate(table_body_results_dict):
                    row = [i+1] + [''] * num_headers
                    match result:
                        case {
                            'binding':{
                                **dct
                            }
                        }: 
                            name = dct.pop('@name', None)
                            for val in dct.values():
                                row[headers_lookup[name]] = val
                                break
                            pass
                        case {
                            'binding': [
                                *tpls
                            ]
                        }:
                            for dct in tpls:
                                name = dct.pop('@name', None)
                                for val in dct.values():
                                    row[headers_lookup[name]] = val
                                    break
                            pass
                        case _:
                            dm(f'Result not matched')
                            dm_pp(result)
                    table_body.append(row)
                    
                    pass
            except Exception as ex:
                dm(str(ex))
                dm("Done expet:\n")
                erout=response.text.split('\n')
                dm(erout)
                pass
        
        default_query=query
        # dm_pp(table_body)
        pass
    
    time_all = time.perftime_all_start = time.perf_counter_ns() - time_all_start
    
    if time_translate is not None:
        time_translate = f'{round(time_translate / 1_000_000)} ms'
        time_query = f'{round(time_query / 1_000_000)} ms'
        time_all = f'{round(time_all / 1_000_000)} ms'
    
    # time_all = time_all.mi
        
    return render_template(
        'execute.html', 
        res_text=rout, 
        err_text=erout, 
        default_query=default_query,
        table_headers=table_headers,
        table_content=table_body,
        show_timings=show_timings,
        time_translate=time_translate,
        time_translate_inner=time_translate_inner,
        time_query=time_query,
        time_all=time_all,
    )


@app.route('/instructions')
def instructions():
    return render_template("instructions.html")



@app.route('/sparql')
def sparql():
    q = request.args.get('query')
    # http://127.0.0.1:5000/sparql?query="ksdjaf"
    if not q:
        dm(f"Request didn't contain a query, {request.text}")
        return make_response("Record not found", 400)
    
    dm("all good.")
    res = requests.get('http://virtuoso_box:8890/sparql', params={'query': q})
    dm(f"{res.text=}, {res.status_code=}, headers: {res.raw.headers.items()}")
    
    new_content = gzip.compress(res.content)
    
    resp = Response(new_content, res.status_code, res.raw.headers.items())
    dm(f"{resp=}")

    return resp
