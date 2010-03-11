// Agent Matchmaker in project ElectronicMarket.mas2j

/* Initial beliefs and rules */
//item (id, name, price, type (offer/request), agent_name)
//update the beliefs in case item is sold
current_item_id(1).
item (ID, Name, Price, Type, Agent) :- current_item_id(ID+1) & not current_item_id(ID).

/* Initial goals */

!start.

/* Plans */

+!start : true <- .print("Electronic Market open!").

+offer(Name, Price)[source(A)] : current_item_id(X) <- .print("Item ", Name, " offered.");+item(X, Name, Price, offer, A).
+requested(Name, Price)[source(A)] : current_item_id(X) <- .print("Item ", Name, " requested.");+item(X, Name, Price, request, A).

//search plans
+search(Type, Name, Price)[source(A)] : item(ID, Name, Price, Type, B) <- .print("Search success");.send(A, tell, item(ID, Name, Price, Type, B)); -search(Type, Name, Price)[source(A)].

+search(Type, Name, 0)[source(A)] : item(ID, Name, Price, Type, B) <- .print("Search success with item ", Name," and price ",Price);.send(A, tell, item(ID, Name, Price, Type, B)); -search(Type, Name, 0)[source(A)].

+search(Type, Name, Price)[source(A)] : ((Price > 0) & (not item(ID, Name, Price, Type, B))) | ((Price=0) & (not item(ID, Name, _, Type, B)))
										<- .print("Search fail");.send(A, tell, empty_search(Name, Price)); -search(Type, Name, Price)[source(A)].
										



