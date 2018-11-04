use master 
use NORTHWND

/*1*/
select CompanyName,c.CustomerID from Customers C inner join Orders O on  c.CustomerID = o.CustomerID
where ShippedDate is null

/*2*/

select CompanyName,c.CustomerID,Quantity from Customers c inner join Orders O on  c.CustomerID = o.CustomerID
inner join [Order Details] r on o.OrderID = r.OrderID where ShippedDate is null
/*3*/

select o.ShipCountry,o.ShipCity,o.ShipPostalCode,COUNT(o.OrderID) as 'Cantidad' 
from Orders o inner join Customers c on 
c.CustomerID = o.CustomerID 
where c.PostalCode <> o.ShipPostalCode or c.City <> o.ShipCity
group by o.ShipCountry,o.ShipCity,o.ShipPostalCode

/*4*/
select s.ShipperID , s.CompanyName from Shippers s 
INNER JOIN ORDERS o on s.ShipperID = o.ShipVia 
where MONTH(ShippedDate) = 1 or MONTH(ShippedDate) = '2' AND YEAR(ShippedDate) = '1998'
AND ShipCountry = 'Mexico'
group by s.ShipperID, s.CompanyName
/*5*/
select FirstName,ReportsTo from Employees

select e.FirstName,e.LastName,a.FirstName,a.LastName 
from Employees e inner join Employees a on e.ReportsTo = a.EmployeeID 

/*6*/
select YEAR(o.OrderDate) as 'AÑO',e.Country, Monto = SUM(r.Quantity*r.UnitPrice*(1-r.Discount))
from Employees e inner join Orders o
on e.EmployeeID = o.EmployeeID  join [Order Details] r on o.OrderID = r.OrderID
group by e.Country,YEAR(o.OrderDate)
order by 1 asc, 3 desc
 

