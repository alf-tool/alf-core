## Why Alf?

The end of the relational era has been predicted many times since the middle of 90'. As of today, it has not been replaced by XML, nor by Object-Oriented databases, and I strongly predict that it won't be superseded by NoSQL technologies. 

As a few others, I'm convinced that the so-called 'relational model' won't disappear. There are very good reasons for this, that have been explained in depth elsewhere. At the heart of those reasons, the relational 'kernel' **is** a theory: a **sound**, **mathematical**, **powerful**, and **simple** theory. Almost all 'alternatives' are not.

Unfortunately, the relational theory is as unknown (or at least ill-known) as it is powerful. Therefore, continuous effort is required to let people know what relational is about, what we would strongly miss if it had to be thrown away.

Two kinds of efforts are needed: writings and tools. Alf mostly belongs to the second category. It is a relational tool, more precisely a pragmatic implementation of a flavor of **relational algebra**. You can use it both in Ruby and in Shell, using .csv files, DBMS tables, apache log files, etc. as input data sources.

Yep, Alf is not about SQL. It is not even about databases, in fact. The relational theory covers a lot of (somewhat independent) concepts. One of them is the relational algebra. In the same way as classical algebra has been invented for 
