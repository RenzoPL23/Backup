use master
create database Certificacion

create table TipoVehiculo(
	CodTIpoVehiculo char(10) not null primary key,
	NombreTipoVehiculo varchar(30),
	)
create table Empleado(
	CodEmpleado char(10) not null primary key,
	Nombre varchar (20),
	Apellido varchar (20),
	Dirección varchar (50),
	telefono int,
	DNI int,
)
create table IngSupervisor(
	CodIngsup char(10) not null primary key,
	CodEmpleado char(10) not null foreign key references Empleado,
	NumAcreditacion int not null,
	HoraIngeniero int 
)
create table Operario(
	CodOperario char(10) not null primary key,
	CodEmpleado char(10) not null foreign key references Empleado,
	HoraOperario int
)
create table Area(
	CodArea char(10) not null primary key,
	nombre varchar(10)
)
create table Equipo(
	CodEquipo char(10) not null primary key,
	CodArea char(10) not null foreign key references Area,
	TipoEquipo varchar(10),
	NombreEquipo varchar(10)
)

create table [Equipo Operario](
	CodOperario char(10) not null references Operario,
	CodEquipo char(10) not null references Equipo,
	primary key (CodOperario,CodEquipo) 
)
select * from [Equipo Operario]