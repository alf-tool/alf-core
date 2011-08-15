## Frequently Asked Questions

* Licensing?

>> Alf is distributed under a MIT licence. 

* Does Alf modify .csv files of SQL tables taken as input?

>> No. Alf is the implementation of relational algebra, which is read-only by nature. Alf operators take relations as input and output a relation (on standard output when used in shell). Input relations are never updated.

* Does Alf compile to SQL code?

>> No. Our roadmap does not go in that particular direction. Have a look at Dan Kubb's [Veritas](https://github.com/dkubb/veritas) project instead.

* Does Alf optimize queries?

>> Not yet. We plan to implement basic optimization strategies in the middle term. 

* How to recognize other data sources and file formats than .csv files and SQL tables?

>> Subclass `Alf::Reader` for new file formats. Subclass `Alf::Environment` for implementing a resolver for named datasources. 
