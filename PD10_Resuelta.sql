use NORTHWND 
/*1*/
SELECT OrderID,CustomerID,OrderDate,ShippedDate,
DATEDIFF(DAY,OrderDate,ShippedDate) as Dias,
DATEDIFF(WEEK,OrderDate,ShippedDate) as Semanas,
DATEDIFF(MONTH,OrderDate,ShippedDate) as Meses
FROM Orders
WHERE DATEDIFF(WEEK,OrderDate,ShippedDate)> 4 
/*2*/

SELECT j.EmployeeID, j.LastName,YEAR(o.OrderDate) as año,
MONTH(o.OrderDate) as mes,
SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) as venta,
SUM(od.Quantity*od.UnitPrice*0.005*(1-od.Discount)) as comision
FROM Employees as e 
 join Employees as j on e.ReportsTo = j.EmployeeID
 join Orders as o on e.EmployeeID = o.EmployeeID 
 join [Order Details] as od on od.OrderID = o.OrderID 
GROUP BY j.EmployeeID, j.LastName,YEAR(o.OrderDate), MONTH(o.OrderDate)

/*3*/
SELECT ShipCountry,YEAR(OrderDate) as año,SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) as venta 
FROM Orders as o
join [Order Details] as od on o.OrderID = od.OrderID
GROUP BY ShipCountry,YEAR(OrderDate)
having SUM(od.Quantity*od.UnitPrice*(1-od.Discount))> 45000 
order by 3 desc
/*4*/
SELECT p.ProductID,p.ProductName, SUM(od.Quantity)as vendidas,
COUNT(od.OrderID) as 'cantidad Ordenes'
FROM Products as p  join [Order Details] as od 
on p.ProductID = od.ProductID
join Orders as o on o.OrderID = od.OrderID
where  YEAR(o.OrderDate) = 1997
group by p.ProductID,p.ProductName
having COUNT(od.OrderID) >=20
/*5*/
SELECT p.ProductName,p.UnitsInStock,
		SUM(od.Quantity) as pendiente,
		SUM(od.Quantity) - p.UnitsInStock as faltante
FROM Products as p join [Order Details] as od on od.ProductID=p.ProductID
				   join Orders as o on o.OrderID = od.OrderID
where p.Discontinued<>1 and o.ShippedDate is null
group by p.ProductName,p.UnitsInStock
having p.UnitsInStock< SUM(od.Quantity)

/*6*/
SELECT p.ProductName,p.UnitPrice
FROM Products AS p
WHERE p.Discontinued<>0 and ((SELECT SUM(p.UnitPrice) FROM Products AS p)/
(SELECT COUNT(p.ProductID) FROM Products AS p))>p.UnitPrice
/*7*/
SELECT o.OrderID, o.OrderDate,o.ShippedDate, 
DATEDIFF(DAY,o.OrderDate,o.ShippedDate) as Diferencia FROM Orders as o
WHERE ((SELECT SUM(DATEDIFF(DAY,o.OrderDate,o.ShippedDate)) FROM Orders as o)
/(SELECT COUNT(o.OrderID) From Orders as o))< DATEDIFF(DAY,o.OrderDate,o.ShippedDate)

/*8*/
SELECT po.ProductID,po.ProductName,po.CategoryID, po.UnitPrice FROM Products as po
WHERE po.Discontinued<>1 
and exists
(SELECT SUM(p.UnitPrice)/COUNT(p.CategoryID)FROM Products as p 
group by p.CategoryID having p.CategoryID = po.CategoryID and SUM(p.UnitPrice)/COUNT(p.CategoryID) < po.UnitPrice) 
/*9*/

select p.ProductID,p.ProductName, p.CategoryID from Products as p
where p.Discontinued<>1 and p.CategoryID = 8 and p.ProductID 
 NOT IN (SELECT po.ProductID FROM Products as po join [Order Details] as od on od.ProductID = po.ProductID
		join Orders as o on o.OrderID = od.OrderID 
		where po.CategoryID= 8 and po.Discontinued <>1 and o.OrderDate between '19960801'and '19960815' )

/*10*/
SELECT TOP 1 p.CategoryID,
(SELECT c.CategoryName FROM Categories as c where p.CategoryID = c.CategoryID) as CategoryName,
COUNT(p.CategoryID) as Cantidad
FROM Products as p 
group by p.CategoryID 
order by COUNT(p.CategoryID) desc
/*11*/

create view VP
as
select c.CategoryID,c.CategoryName,
		p.ProductID, p.ProductName, SUM(od.Quantity) 'Cantidad'
from Categories as  c join Products as p on c.CategoryID=p.CategoryID
		      join [Order Details]  as od on p.ProductID=od.ProductID
		      join Orders as o on od.OrderID=o.OrderID
where YEAR(o.OrderDate)=1997
group by c.CategoryID,c.CategoryName,p.ProductID, p.ProductName

create view MC
 as
select vw1.CategoryID,vw1.CategoryName,MAX(vw1.Cantidad) as 'maximo'
from VP as vw1
group by vw1.CategoryID,vw1.CategoryName

select vw1.CategoryID,vw1.CategoryName,vw1.ProductID,vw1.ProductName,vw2.maximo
from VP as  vw1 join mc as vw2 on vw1.CategoryID=vw2.CategoryID
where vw1.Cantidad=vw2.maximo
order by 1

/*12*/

create view cw_monto_pais
as 
select o.ShipCountry,o.OrderID, SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) as monto   
from Orders as o join [Order Details] as od on o.OrderID=od.OrderID 
group by o.ShipCountry,o.OrderID
order by 1

create view cw_pais_maximo
as 
select vw1.ShipCountry,MAX(vw1.monto) as maximo
from cw_monto_pais as vw1
group by vw1.ShipCountry

select vw1.ShipCountry,vw1.OrderID,vw2.maximo 
from cw_monto_pais as vw1 join cw_pais_maximo as vw2 on
vw1.ShipCountry=vw2.ShipCountry
where vw1.monto = vw2.maximo
order by 1

