# OASLRepository
OpenAPI descriptions detail the actions exposed by REST APIs in
YAML or JSON syntax. The semantics of valid OpenAPI descriptions can be
further exploited if they can be mapped to an OpenAPI ontology, as we have
done in our previous work. However, queries become complex and require
the user to be familiar with the peculiarities of the ontology. 
The OpenAPI SPARQL Language (OASL), is an RDF query language for OpenAPI semantic descriptions. To formulate an OASL query, a user needs only
a basic understanding of SPARQL and no knowledge of the OpenAPI ontology. OASL builds on top of SPARQL and simplifies query complexity,
so even highly complex SPARQL queries can be expressed using only a few
OASL statements. The web service consists of UI built using Flask , the OASL compiler in JAR files and a Virtuoso database. Both of them are executing using docker containers.
