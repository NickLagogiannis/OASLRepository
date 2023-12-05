Open API SPARQL Language (OASL) Web Service
=====================================================================
OpenAPI descriptions detail the actions exposed by REST APIs in
YAML or JSON syntax. The semantics of valid OpenAPI descriptions can be
further exploited if they can be mapped to an OpenAPI ontology, as we have
done in our previous work. However, queries become complex and require
the user to be familiar with the peculiarities of the ontology. 
The OpenAPI SPARQL Language (OASL), is an RDF query language for OpenAPI semantic descriptions. To formulate an OASL query, a user needs only
a basic understanding of SPARQL and no knowledge of the OpenAPI ontology. OASL builds on top of SPARQL and simplifies query complexity,
so even highly complex SPARQL queries can be expressed using only a few
OASL statements. The web service consists of UI built using Flask , the OASL compiler in JAR files and a Virtuoso database. Both of them are executing using docker containers.


## Installation
***
  Install docker and Docker compose 
  
  Download the project
  
  Inside the root directory of the project run :
  
       docker-compose up --build
    
When the building process is completed you are able to acsess the site.

## Usage Description
***
In order to use this app you have to accsess to port **8085**

 | Path                | Returns      |                                                                                                                   
|---------------------|--------------------------------------------------------------------------------------|
| /                   | A simple home page giving instructions about the other tabs and how to use them.|
| /upload             | Redirects to the page where you can uplload the openAPI files in ttl format. **Select File** opens a window to check wich files you want to upload, then press the **Upload** button and after the uploading is completed, returns the number of files where they uploaded.|
| /instructions       | Contains a PDF file with all the available triples you can query.|
| /execute            | This tab contains a placeholder where you can write the OASL code. By pressing **Submit** button , return in tabular format the expected results. In case of an error syntax, returns an appropriate message. |


## Refrences
***

* Nikolaos Lagogiannis, Nikolaos Mainas, Chrisa Tsinaraki, and
      Euripides G.M. Petrakis, “OASL: SPARQL Query Language for
      OpenAPI Ontologies”, 37th International Conference on Advanced
      Information Networking and Applications (AINA 2023), Juiz de Fora,
      Brazil, March 29-31, 2023. https://link.springer.com/chapter/10.1007/978-3-031-28451-9_27

* Nikolaos Lagogiannis, "OpenAPI SPARQL: Querying OpenAPIOntologies in OWL", Diploma Work, School of Electrical and Computer Engineering, Technical University of Crete, Chania, Greece, 2022.  https://doi.org/10.26233/heallink.tuc.93679       


    
