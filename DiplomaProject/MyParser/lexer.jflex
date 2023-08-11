package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%

%class Lexer
%implements sym
%public
%unicode
%line
%column
%cup
%char
%{
	

    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;
    public String restring="";

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

Newline    = \r | \n | \r\n
//Whitespace = [ \t\f] | {Newline}


Whitespace = [ \t\n]+

COMPARATORS     =("<"|"<="|">"|">=")
L_PAR            = "("
R_PAR            = ")"
L_CULR_BRACK     = "{"
R_CULR_BRACK     = "}"
COL              = ":"
AGGR_TK          = "*"
COMMA            = ","
DOT            = "."

quote           = "\""
BETWEEN_KW = ("BETWEEN" |"between")

/* Column 1 Class */



Response = Response
Request = Request
Service = Service
Server = Server
Security = Security
SecurityScope = SecurityScope
RequestHeader = RequestHeader
ResponseHeader = ResponseHeader
Header = Header
Parameter = Parameter
Schema = Schema
Property_class = Property
Tag = Tag

/* Column 2 properties*/

title_property = title
ex_doc_url = externalDocUrl
ex_doc_desc = externalDocDescription
c_url = contactUrl
c_name = contactName
l_name = liscenseName
l_des = liscenseDescription
vers = version
method = method
path = path
schema_property = schema
contentType = contentType
header_property = header
tag_property = tag
summ = summary
b_desc = bodyDescription
url = url
desc = description
email = email
name = name
opName = operationName
style = style
req = required
emValue = allowEmptyValue
res = allowReserved
depr = deprecated
loc = location
in = apiKeyIn
AKname = apiKeyName
format = httpBearrerFormat
OpenIdConnectUrl = OpenIdConnectUrl
AuthUrl = OAuth2AuthUrl
RefreshUrl = OAuth2RefreshUrl
TokenUrl = OAuth2TokenUrl
OAuth2flowType = OAuth2flowType
securityType = securityType
scheme = scheme
sCodeRange = statusCodeRange
sCode = statusCode
property = property
dataType = dataType
maximum = maximum
minimum = minimum
minProperties = minProperties
maxProperties = maxProperties
minLength = minLength
maxLength = maxLength
minCount = minCount 
maxCount = maxCount

type = type 

/* Column 3 Object literals etc */

        /*special keywords */
accepted_methods    = (GET|PUT|POST|DELETE)
flow_types          = (Implicit|ClientCredentials|Password|AuthCode)
sec_types           = (OAuth2|ApiKey|OpenIdConnect|Http)
resXX               = [1-5]"XX"

styles              = (simple|form|label|matrix|pipeDelimited|spaceDelimited)
in_pos              = (Path|Header|Query|Cookie)
common_types        = (integer|number|string|boolean|array)        // na xanado to number
BOOL                = ("false"|"FALSE"|"true"|"TRUE")



letter = [A-Za-z]
var = "?"[a-zA-Z_][0-9a-zA-Z_]*

special_char = ("!"|"@"|"#"|"$"|"^"|"&"|"*"|":"|"."|"("|")"|"+"|"-"|"^"|"/"|"_"|"~"|" "|","|"."|"\\")
// string =\"({letter}|{digit}|{special_char})*\"
string = {quote}(\\.|[^\"])* {quote}


//Number     = [0-9]+
word = {letter}+
digit =[0-9]
integer ={digit}+
float =({integer}("."{integer}))
Number = {float} | {integer} 

/* syntax Keywords */
PREFIX_KW      = PREFIX
SELECT_KW      = SELECT
DISTINCT_KW      = DISTINCT
WHERE_KW       = WHERE
ORDER_KW       = "ORDER BY "("desc"|"asc")
LIMIT_KW       = LIMIT
OFFSET_KW      = OFFSET
OR_KW          = ("OR"|"or")
// NEEDS FURTHER CONSIDERATION

NOT_KW         = "NOT"
OPT_KW         = "OPTIONAL"
//////////          NOT MY CODE       !!!!!!!!!!!!!!!!!!

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment}
TraditionalComment = "/*" {CommentContent} \*+ "/"
EndOfLineComment = "//" [^\r\n]* {Newline}
CommentContent = ( [^*] | \*+[^*/] )*

uri = "<"([:jletter:]|[:jletterdigit:])([:jletterdigit:] | [:jletter:] | "/" | "." | "#" | {COL})*">"
ident = [A-Za-z_$] [A-Za-z_$0-9]* //([:jletter:] | "_" ) ([:jletterdigit:] | [:jletter:] | "_" )*


%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

//////////          NOT MY CODE       !!!!!!!!!!!!!!!!!!

%%  

<YYINITIAL> {

{PREFIX_KW}     { return symbolFactory.newSymbol("PREFIX_KW", PREFIX_KW); 			}
{SELECT_KW}     { return symbolFactory.newSymbol("SELECT_KW", SELECT_KW); 			}
{DISTINCT_KW}   { return symbolFactory.newSymbol("DISTINCT_KW", DISTINCT_KW); 		}
{WHERE_KW}      { return symbolFactory.newSymbol("WHERE_KW", WHERE_KW); 			}
{ORDER_KW}      { return symbolFactory.newSymbol("ORDER_KW", ORDER_KW , yytext());	} 
{LIMIT_KW}      { return symbolFactory.newSymbol("LIMIT_KW", LIMIT_KW); 			}
{OFFSET_KW}     { return symbolFactory.newSymbol("OFFSET_KW", OFFSET_KW); 			}



{uri}           { return symbolFactory.newSymbol("uri", uri,yytext()); }
{var}			{ return symbolFactory.newSymbol("var", var , yytext()); }


{COMPARATORS}     { return symbolFactory.newSymbol("COMPARATORS", COMPARATORS, yytext()); } 

{BETWEEN_KW}		{ return symbolFactory.newSymbol("BETWEEN_KW", BETWEEN_KW); } 


// SYMBOL TOKENS
{L_PAR}          { return symbolFactory.newSymbol("L_PAR", LPAR); }
{R_PAR}          { return symbolFactory.newSymbol("R_PAR", RPAR); }
{L_CULR_BRACK}    { return symbolFactory.newSymbol("L_CULR_BRACK", L_CULR_BRACK); }
{R_CULR_BRACK}    { return symbolFactory.newSymbol("R_CULR_BRACK", R_CULR_BRACK); }
{COL}             { return symbolFactory.newSymbol("COL", COL); }
{AGGR_TK}            { return symbolFactory.newSymbol("AGGR_TK", AGGR_TK); } 
{COMMA}           { return symbolFactory.newSymbol("COMMA", COMMA); } 
{DOT}           { return symbolFactory.newSymbol("DOT", DOT); } 
// return symbolFactory.newSymbol("OR_KW",ORKW);
{OR_KW}      	{ return symbolFactory.newSymbol("OR_KW",OR_KW);}
{NOT_KW}     { return symbolFactory.newSymbol("NOT_KW", NOT_KW); }
{OPT_KW}     { return symbolFactory.newSymbol("OPT_KW", OPT_KW); }


// OPEN API OBJECTS 

{Response}  	 	{ return symbolFactory.newSymbol("Response", Response); }
{Request}   		{ return symbolFactory.newSymbol("Request", Request); }
{Service}   		{ return symbolFactory.newSymbol("Service", Service); }
{Parameter}   	{ return symbolFactory.newSymbol("Parameter", Parameter); }
{Security}   		{ return symbolFactory.newSymbol("Security", Security); }
{RequestHeader}   		{ return symbolFactory.newSymbol("RequestHeader", RequestHeader); }
{ResponseHeader}   		{ return symbolFactory.newSymbol("ResponseHeader", ResponseHeader); }
{Header}   		{ return symbolFactory.newSymbol("Header", Header); }
{Schema} 			{ return symbolFactory.newSymbol("Schema", Schema); }
{Property_class} 	{ return symbolFactory.newSymbol("Property_class", Property_class); }
{Tag} 			{ return symbolFactory.newSymbol("Tag", Tag); }
{Server} 			{ return symbolFactory.newSymbol("Server", Server); }
{SecurityScope} 	{ return symbolFactory.newSymbol("SecurityScope", SecurityScope); }

// PROPERTIES



    // Service
    {title_property}    { return symbolFactory.newSymbol("title_property", title_property); }
    {ex_doc_url}        { return symbolFactory.newSymbol("ex_doc_url", ex_doc_url); }
    {ex_doc_desc}       { return symbolFactory.newSymbol("ex_doc_desc", ex_doc_desc); }
    {c_url}             { return symbolFactory.newSymbol("c_url", c_url); }
    {c_name}            { return symbolFactory.newSymbol("c_name", c_name); }
    {l_name}            { return symbolFactory.newSymbol("l_name", l_name); }
    {l_des}             { return symbolFactory.newSymbol("l_des", l_des); }
    {vers}              { return symbolFactory.newSymbol("vers", vers); }

    // Response
    {sCodeRange}   { return symbolFactory.newSymbol("sCodeRange", sCodeRange); }
    {sCode}        { return symbolFactory.newSymbol("sCode", sCode); }
    {desc}          { return symbolFactory.newSymbol("desc", desc); }
    // Request

    {method}            { return symbolFactory.newSymbol("method", method); }
    {path}              { return symbolFactory.newSymbol("path", path); }
    {schema_property}   { return symbolFactory.newSymbol("schema_property", schema_property); }
    {contentType}       { return symbolFactory.newSymbol("contentType", contentType); }
    {header_property}   { return symbolFactory.newSymbol("header_property", header_property); }
    {tag_property}   { return symbolFactory.newSymbol("tag_property", tag_property); }
    {summ}              { return symbolFactory.newSymbol("summ", summ); }
    {b_desc}            { return symbolFactory.newSymbol("b_desc", b_desc); }
    {opName}              { return symbolFactory.newSymbol("opName", opName); }

    // Header , Parameter
    {style}             { return symbolFactory.newSymbol("style", style); }
    {req}               { return symbolFactory.newSymbol("req", req); }
    {name}              { return symbolFactory.newSymbol("name", name); }
    {loc}               { return symbolFactory.newSymbol("loc", loc); }
    {emValue}           { return symbolFactory.newSymbol("emValue", emValue); }
    {res}               { return symbolFactory.newSymbol("res", res); }
    {depr}              { return symbolFactory.newSymbol("depr", depr); }
	
	// Server
	{url} 				{ return symbolFactory.newSymbol("url", url); }
	
    // Security

    {in}                { return symbolFactory.newSymbol("in", in); }
    {AKname}            { return symbolFactory.newSymbol("AKname", AKname); }
    {format}            { return symbolFactory.newSymbol("format", format); }
    {scheme}			{ return symbolFactory.newSymbol("scheme", scheme); }
    {OpenIdConnectUrl}  { return symbolFactory.newSymbol("OpenIdConnectUrl", OpenIdConnectUrl); }
    {AuthUrl}           { return symbolFactory.newSymbol("AuthUrl", AuthUrl); }
    {RefreshUrl}        { return symbolFactory.newSymbol("RefreshUrl", RefreshUrl); }
    {TokenUrl}          { return symbolFactory.newSymbol("TokenUrl", TokenUrl); }
    {OAuth2flowType}    { return symbolFactory.newSymbol("OAuth2flowType", OAuth2flowType); }
    {securityType}      { return symbolFactory.newSymbol("securityType", securityType); }

    // Schema

    {property}          { return symbolFactory.newSymbol("property", property); }
    {minProperties}     { return symbolFactory.newSymbol("minProperties", minProperties); }
    {maxProperties}     { return symbolFactory.newSymbol("maxProperties", maxProperties); }
    {minLength}         { return symbolFactory.newSymbol("minLength", minLength); }
    {maxLength}         { return symbolFactory.newSymbol("maxLength", maxLength); }
    {minCount}         { return symbolFactory.newSymbol("minCount", minCount); }
    {maxCount}         { return symbolFactory.newSymbol("maxCount", maxCount); }
    {type}              { return symbolFactory.newSymbol("type", type); }
    {dataType}              { return symbolFactory.newSymbol("dataType", dataType); }
    {maximum}           { return symbolFactory.newSymbol("maximum", maximum); }
    {minimum}           { return symbolFactory.newSymbol("minimum", minimum); }


  {accepted_methods} {return symbolFactory.newSymbol("accepted_methods", accepted_methods, yytext()); }
  {resXX}            {return symbolFactory.newSymbol("resXX", resXX, yytext()); }
  {flow_types}        {return symbolFactory.newSymbol("flow_types", flow_types, yytext()); }
  {sec_types}           {return symbolFactory.newSymbol("sec_types", sec_types, yytext()); }
  {styles}             {return symbolFactory.newSymbol("styles", styles, yytext()); }
  {in_pos}             {return symbolFactory.newSymbol("in_pos", in_pos, yytext()); }
  {common_types}       {return symbolFactory.newSymbol("common_types", common_types, yytext()); }        // na xanado to number
  /*{BOOL_T}              {return symbolFactory.newSymbol("BOOL_T", BOOL_T, yytext()); }
  {BOOL_F}              {return symbolFactory.newSymbol("BOOL_F", BOOL_F, yytext()); }*/
  {BOOL}              {return symbolFactory.newSymbol("BOOL", BOOL, yytext()); }

  {Whitespace} {                   }
  {Newline}     {           }

  {Number}     		{ return symbolFactory.newSymbol("NUMBER", NUMBER, yytext()); }

  
  


  
  {ident}           {return symbolFactory.newSymbol("ident", ident , yytext()); }
  
  {string}          {return symbolFactory.newSymbol("string", string , yytext()); }
}



// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
