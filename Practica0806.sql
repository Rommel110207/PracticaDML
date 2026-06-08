-- Parte I Creación de Estructuras (CREATE)

if not exists (select * from sys.databases where name = 'EmpresaSQL')
begin
create database EmpresaSQL
end
go
use EmpresaSQL 
go


--Tabla Empleado

if not exists (select * from sys.tables where name = 'TDepartamento')

begin
create table TDepartamento (nDepartamentoID int identity(1,1) constraint PK_TDepartamento primary key , cNombreDepartamento varchar (100) unique not null)
end 
go

--Tabla Cargo
if not exists (select * from sys.tables where name = 'TCargo')
begin
create table TCargo(nCargoID int  identity (1,1) constraint PK_Tcargo primary key, cNombreCargo varchar (100) unique not null)
end
go
--Tabla Empleado
if not exists (select * from sys.tables where name = 'TEmpleado')
begin
create table TEmpleado(nEmpleadoID int identity (1,1) constraint PK_Templeado primary key ,cNIF varchar (20)unique, cNombre varchar(15), apellido varchar(20), nDepartamentoID int foreign key references TDepartamento, nCargoID int foreign key references Tcargo, dFechaContratacion date constraint DF_TEmpleado_FechaContratacion default getdate(), nsalario decimal (10,2) check(nsalario>300))
end
go
-- Crear tabla TProyecto
if not exists (select * from sys.tables where name = 'TProyecto')
begin
create table TProyecto(IDProyecto int identity(1,1) constraint PK_TProyecto primary key)
end
go


-- Agregar campo nombre del proyecto obligatorio
alter table TProyecto add cNombreProyecto varchar(100) not null;
go

-- Agregar fecha de inicio obligatoria
alter table TProyecto add dFechaInicio date not null;
go

-- Agregar fecha de finalización
alter table TProyecto add dFechaFinalizacion date;
go

-- Crear tabla intermedia TEmpleado Proyecto para relación muchos a muchos
if not exists (select * from sys.tables where name = 'TEmpleadoProyecto')
begin
create table TEmpleadoProyecto (
    nEmpleadoID int foreign key references TEmpleado(nEmpleadoID),
    IDProyecto int foreign key references TProyecto(IDProyecto),
    constraint PK_TEmpleadoProyecto primary key (nEmpleadoID, IDProyecto)
)
end
go



-- Parte II. Modificación de Estructuras (ALTER)


-- Agregar columna cEmail a TEmpleado
alter table TEmpleado add cEmail varchar(100);
go

-- Agregar columna cTelefono
alter table TEmpleado add cTelefono varchar(15);
go

-- Modificar longitud de cNombre a 100 caracteres
alter table TEmpleado alter column cNombre varchar(100);
go

-- Modificar longitud de cApellido a 100 caracteres
alter table TEmpleado alter column apellido varchar(100);
go

-- Agregar columna cDireccion
alter table TEmpleado add cDireccion varchar(200);
go

-- Agregar columna nEdad
alter table TEmpleado add nEdad int;
go

-- Crear restricción CHECK para edades entre 18 y 65 años
alter table TEmpleado add constraint CK_TEmpleado_Edad check (nEdad between 18 and 65);
go

-- Agregar restricción UNIQUE al correo electrónico
alter table TEmpleado add constraint UQ_TEmpleado_Email unique (cEmail);
go

-- Agregar columna bActivo tipo BIT con valor por defecto 1
alter table TEmpleado add bActivo bit constraint DF_TEmpleado_Activo default 1;
go

-- Eliminar la columna cDireccion
alter table TEmpleado drop column cDireccion;
go

-- Cambiar el tipo de dato de teléfono a VARCHAR(20)
alter table TEmpleado alter column cTelefono varchar(20);
go

-- Agregar columna cGenero
alter table TEmpleado add cGenero char(1);
go

-- Agregar restricción CHECK para que el género solo permita M o F
alter table TEmpleado add constraint CK_TEmpleado_Genero check (cGenero in ('M', 'F'));
go

-- Agregar columna dFechaNacimiento
alter table TEmpleado add dFechaNacimiento date;
go

-- Crear una nueva tabla llamada TSucursal
if not exists (select * from sys.tables where name = 'TSucursal')
begin
create table TSucursal (
    nSucursalID int identity(1,1) constraint PK_TSucursal primary key,
    cNombreSucursal varchar(100) not null
)
end
go



-- Parte III. Inserción de Datos (INSERT)


-- Insertar 5 departamentos diferentes
insert into TDepartamento (cNombreDepartamento) values 
('Contabilidad'), ('Sistemas'), ('Recursos Humanos'), ('Ventas'), ('Logistica');
go

-- Insertar 5 cargos diferentes
insert into TCargo (cNombreCargo) values 
('Gerente'), ('Analista'), ('Asistente'), ('Desarrollador'), ('Supervisor');
go

-- Insertar 10 empleados
insert into TEmpleado (cNIF, cNombre, apellido, nDepartamentoID, nCargoID, dFechaContratacion, nsalario, cEmail, cTelefono, nEdad, bActivo, cGenero, dFechaNacimiento) values
('12345678A', 'Juan', 'Perez', 1, 1, '2023-01-15', 1500.00, 'juan.perez@empresa.com', '88881111', 30, 1, 'M', '1993-05-12'),
('23456789B', 'Maria', 'Gomez', 2, 4, '2024-02-10', 1200.00, 'maria.gomez@empresa.com', '88882222', 25, 1, 'F', '1998-08-20'),
('34567890C', 'Carlos', 'Lopez', 2, 2, '2022-05-20', 1100.00, 'carlos.lopez@empresa.com', '88883333', 40, 1, 'M', '1983-11-02'),
('45678901D', 'Ana', 'Martinez', 3, 3, '2021-07-01', 350.00, 'ana.martinez@empresa.com', '88884444', 28, 1, 'F', '1995-03-15'),
('56789012E', 'Luis', 'Rodriguez', 4, 5, '2025-09-15', 950.00, 'luis.rodriguez@empresa.com', '88885555', 35, 1, 'M', '1989-12-25'),
('67890123F', 'Elena', 'Fernandez', 1, 3, '2020-11-30', 400.00, 'elena.fernandez@empresa.com', '88886666', 50, 1, 'F', '1973-04-05'),
('78901234G', 'Pedro', 'Garcia', 5, 2, '2026-01-10', 1300.00, 'pedro.garcia@empresa.com', '88887777', 45, 1, 'M', '1980-07-19'),
('89012345H', 'Sofia', 'Gutierrez', 2, 4, '2026-03-22', 1600.00, 'sofia.gutierrez@empresa.com', '88888888', 29, 1, 'F', '1996-09-01'),
('90123456I', 'Jorge', 'Sanchez', 4, 3, '2023-04-18', 850.00, 'jorge.sanchez@empresa.com', '88889999', 33, 1, 'M', '1991-01-30'),
('01234567J', 'Lucia', 'Diaz', 5, 5, '2024-06-05', 1050.00, 'lucia.diaz@empresa.com', '88880000', 38, 1, 'F', '1986-10-14');
go

-- Insertar 3 proyectos
insert into TProyecto (cNombreProyecto, dFechaInicio, dFechaFinalizacion) values
('Proyecto Alfa', '2026-01-01', '2026-06-30'),
('Proyecto Beta', '2026-02-15', '2026-12-31'),
('Proyecto Gamma', '2026-03-01', null);
go

-- Asignar empleados a proyectos
insert into TEmpleadoProyecto (nEmpleadoID, IDProyecto) values
(1, 1), (2, 1), (3, 1),
(4, 2), (5, 2),
(6, 3);
go

-- Insertar un empleado utilizando el valor por defecto de fecha
insert into TEmpleado (cNIF, cNombre, apellido, nDepartamentoID, nCargoID, nsalario, cEmail, cTelefono, nEdad, bActivo, cGenero, dFechaNacimiento)
values ('11112222K', 'Miguel', 'Alvarez', 1, 2, 1400.00, 'miguel.alvarez@empresa.com', '99998888', 32, 1, 'M', '1994-02-12');
go

-- Insertar un empleado con correo electrónico
insert into TEmpleado (cNIF, cNombre, apellido, nDepartamentoID, nCargoID, dFechaContratacion, nsalario, cEmail, cTelefono, nEdad, bActivo, cGenero, dFechaNacimiento)
values ('22223333L', 'Laura', 'Torres', 3, 3, '2025-05-05', 600.00, 'laura.torres@empresa.com', '77776666', 27, 1, 'F', '1999-06-18');
go

-- Insertar un empleado sin indicar estado activo
insert into TEmpleado (cNIF, cNombre, apellido, nDepartamentoID, nCargoID, dFechaContratacion, nsalario, cEmail, cTelefono, nEdad, cGenero, dFechaNacimiento)
values ('33334444M', 'Roberto', 'Ruiz', 4, 2, '2025-08-20', 750.00, 'roberto.ruiz@empresa.com', '55554444', 41, 'M', '1985-03-24');
go

-- Insertar registros usando múltiples VALUES
-- (Nota: Este requerimiento ya queda cumplido y aplicado en las inserciones grupales anteriores)
go

-- Intentar insertar un salario negativo y analizar el error
-- insert into TEmpleado (cNIF, cNombre, apellido, nDepartamentoID, nCargoID, nsalario) values ('00000000X', 'Invalido', 'Test', 1, 1, -100);
go



-- Parte IV. Actualización de Datos (UPDATE)


-- Incrementar en 10% el salario de todos los empleados
update TEmpleado set nsalario = nsalario * 1.10;
go

-- Incrementar en 20% el salario de los empleados de un departamento específico
update TEmpleado set nsalario = nsalario * 1.20 where nDepartamentoID = 2;
go

-- Actualizar el correo electrónico de un empleado
update TEmpleado set cEmail = 'juan.perez.nuevo@empresa.com' where cNIF = '12345678A';
go

-- Modificar el cargo de un empleado
update TEmpleado set nCargoID = 1 where cNIF = '23456789B';
go

-- Cambiar el departamento de dos empleados
update TEmpleado set nDepartamentoID = 4 where cNIF in ('34567890C', '45678901D');
go

-- Marcar como inactivos a los empleados con salario inferior a 500
update TEmpleado set bActivo = 0 where nsalario < 500;
go

-- Actualizar la fecha de finalización de un proyecto
update TProyecto set dFechaFinalizacion = '2026-08-31' where IDProyecto = 1;
go

-- Asignar un nuevo proyecto a un empleado
insert into TEmpleadoProyecto (nEmpleadoID, IDProyecto) values (7, 3);
go



-- Parte V. Eliminación de Datos (DELETE)


-- Eliminar un empleado específico mediante su NIF
delete from TEmpleadoProyecto where nEmpleadoID = (select nEmpleadoID from TEmpleado where cNIF = '22223333L');
delete from TEmpleado where cNIF = '22223333L';
go

-- Eliminar todos los empleados inactivos
delete from TEmpleadoProyecto where nEmpleadoID in (select nEmpleadoID from TEmpleado where bActivo = 0);
delete from TEmpleado where bActivo = 0;
go

-- Eliminar un proyecto específico
delete from TEmpleadoProyecto where IDProyecto = 2;
delete from TProyecto where IDProyecto = 2;
go

-- Eliminar las asignaciones de un empleado en la tabla TEmpleado Proyecto
delete from TEmpleadoProyecto where nEmpleadoID = 1;
go

-- Eliminar un departamento que no tenga empleados asociados
delete from TDepartamento where nDepartamentoID not in (select distinct nDepartamentoID from TEmpleado where nDepartamentoID is not null);
go



-- Parte VI. Consultas de Verificación

-- Mostrar todos los empleados ordenados por apellido
select * from TEmpleado order by apellido;
go

-- Mostrar empleados con salario mayor a 1,000
select * from TEmpleado where nsalario > 1000;
go

-- Mostrar empleados activos
select * from TEmpleado where bActivo = 1;
go

-- Mostrar empleados contratados durante el año actual
select * from TEmpleado where year(dFechaContratacion) = year(getdate());
go

-- Mostrar empleados y el nombre de su departamento
select e.*, d.cNombreDepartamento from TEmpleado e left join TDepartamento d on e.nDepartamentoID = d.nDepartamentoID;
go

-- Mostrar empleados y el nombre de su cargo
select e.*, c.cNombreCargo from TEmpleado e left join TCargo c on e.nCargoID = c.nCargoID;
go

-- Mostrar empleados asignados a proyectos
select distinct e.* from TEmpleado e join TEmpleadoProyecto ep on e.nEmpleadoID = ep.nEmpleadoID;
go

-- Mostrar cantidad de empleados por departamento
select nDepartamentoID, count(*) as CantidadEmpleados from TEmpleado group by nDepartamentoID;
go

-- Mostrar salario promedio por departamento
select nDepartamentoID, avg(nsalario) as SalarioPromedio from TEmpleado group by nDepartamentoID;
go

-- Mostrar salario máximo y mínimo por departamento
select nDepartamentoID, max(nsalario) as SalarioMaximo, min(nsalario) as SalarioMinimo from TEmpleado group by nDepartamentoID;
go

-- Mostrar los proyectos con más de dos empleados asignados
select IDProyecto, count(nEmpleadoID) as CantidadEmpleados from TEmpleadoProyecto group by IDProyecto having count(nEmpleadoID) > 2;
go

-- Mostrar empleados cuyo apellido inicia con "G"
select * from TEmpleado where apellido like 'G%';
go

-- Mostrar empleados ordenados por salario descendente
select * from TEmpleado order by nsalario desc;
go

-- Mostrar los tres salarios más altos
select top 3 nsalario from TEmpleado order by nsalario desc;
go

-- Mostrar empleados con edad entre 25 and 40 años
select * from TEmpleado where nEdad between 25 and 40;
go

-- Mostrar cantidad total de empleados activos
select count(*) as TotalActivos from TEmpleado where bActivo = 1;
go

-- Mostrar el total de proyectos registrados
select count(*) as TotalProyectos from TProyecto;
go



-- Desafíos Adicionales


-- Crear una tabla TCliente con al menos 8 campos y restricciones
if not exists (select * from sys.tables where name = 'TCliente')
begin
create table TCliente (
    nClienteID int identity(1,1) constraint PK_TCliente primary key,
    cNombre varchar(50) not null,
    cApellido varchar(50) not null,
    cDNICedula varchar(20) unique not null,
    cTelefono varchar(20),
    cEmail varchar(100) unique,
    dFechaRegistro date constraint DF_TCliente_Fecha default getdate(),
    bActivo bit constraint DF_TCliente_Activo default 1
)
end
go

-- Crear una tabla TVenta relacionada con TCliente
if not exists (select * from sys.tables where name = 'TVenta')
begin
create table TVenta (
    nVentaID int identity(1,1) constraint PK_TVenta primary key,
    nClienteID int constraint FK_TVenta_TCliente foreign key references TCliente(nClienteID),
    nEmpleadoID int constraint FK_TVenta_TEmpleado foreign key references TEmpleado(nEmpleadoID),
    dFechaVenta date not null,
    nMontoTotal decimal(10,2) check (nMontoTotal >= 0),
    cEstado varchar(20) default 'Completada'
)
end
go

-- Registrar 20 clientes
insert into TCliente (cNombre, cApellido, cDNICedula, cTelefono, cEmail) values
('Carlos', 'Mendoza', '001-010190-0001A', '88881111', 'carlos.m@mail.com'),
('Ana', 'Silva', '001-010191-0002B', '88882222', 'ana.s@mail.com'),
('Sofia', 'Reyes', '001-010192-0003C', '88883333', 'sofia.r@mail.com'),
('David', 'Castro', '001-010193-0004D', '88884444', 'david.c@mail.com'),
('Lucia', 'Mejia', '001-010194-0005E', '88885555', 'lucia.m@mail.com'),
('Jose', 'Ortiz', '001-010195-0006F', '88886666', 'jose.o@mail.com'),
('Laura', 'Flores', '001-010196-0007G', '88887777', 'laura.f@mail.com'),
('Luis', 'Morales', '001-010197-0008H', '88888888', 'luis.m2@mail.com'),
('Elena', 'Espinoza', '001-010198-0009I', '88889999', 'elena.e@mail.com'),
('Pedro', 'Chavez', '001-010199-0010J', '88880000', 'pedro.c@mail.com'),
('Maria', 'Gutierrez', '001-010100-0011K', '77771111', 'maria.g2@mail.com'),
('Juan', 'Bermudez', '001-010101-0012L', '77772222', 'juan.b@mail.com'),
('Andres', 'Miranda', '001-010102-0013M', '77773333', 'andres.m@mail.com'),
('Diana', 'Solorzano', '001-010103-0014N', '77774444', 'diana.s@mail.com'),
('Gabriel', 'Rios', '001-010104-0015O', '77775555', 'gabriel.r@mail.com'),
('Camila', 'Suarez', '001-010105-0016P', '77776666', 'camila.s@mail.com'),
('Ricardo', 'Poveda', '001-010106-0017Q', '77777777', 'ricardo.p@mail.com'),
('Valeria', 'Obando', '001-010107-0018R', '77778888', 'valeria.o@mail.com'),
('Manuel', 'Gaitan', '001-010108-0019S', '77779999', 'manuel.g@mail.com'),
('Tatiana', 'Zeledon', '001-010109-0020T', '77770000', 'tatiana.z@mail.com');
go

-- Registrar 50 ventas
insert into TVenta (nClienteID, nEmpleadoID, dFechaVenta, nMontoTotal) values
(1, 1, '2026-01-10', 150.00), (1, 1, '2026-01-15', 200.00), (2, 3, '2026-01-20', 350.00),
(3, 5, '2026-02-05', 120.00), (4, 7, '2026-02-12', 450.00), (5, 9, '2026-02-18', 90.00),
(6, 1, '2026-03-02', 600.00), (7, 3, '2026-03-14', 250.00), (8, 5, '2026-03-22', 180.00),
(9, 7, '2026-04-01', 300.00), (10, 9, '2026-04-09', 420.00), (11, 1, '2026-04-15', 130.00),
(12, 3, '2026-04-23', 95.00), (13, 5, '2026-05-02', 500.00), (14, 7, '2026-05-11', 75.00),
(15, 9, '2026-05-19', 220.00), (16, 1, '2026-05-25', 110.00), (17, 3, '2026-06-01', 310.00),
(18, 5, '2026-06-04', 415.00), (1, 7, '2026-06-06', 125.00), (2, 9, '2026-01-11', 85.00),
(3, 1, '2026-01-22', 210.00), (4, 3, '2026-02-01', 320.00), (5, 5, '2026-02-19', 430.00),
(6, 7, '2026-03-05', 540.00), (7, 9, '2026-03-12', 65.00), (8, 1, '2026-03-29', 175.00),
(9, 3, '2026-04-04', 285.00), (10, 5, '2026-04-12', 395.00), (11, 7, '2026-04-20', 505.00),
(12, 9, '2026-05-01', 615.00), (13, 1, '2026-05-08', 725.00), (14, 3, '2026-05-15', 85.00),
(15, 5, '2026-05-22', 195.00), (16, 7, '2026-06-02', 205.00), (17, 9, '2026-06-03', 305.00),
(1, 3, '2026-02-20', 99.00), (2, 5, '2026-02-25', 149.00), (3, 7, '2026-03-11', 249.00),
(4, 9, '2026-03-17', 349.00), (5, 1, '2026-04-03', 449.00), (6, 3, '2026-04-16', 59.00),
(7, 5, '2026-04-28', 159.00), (8, 7, '2026-05-04', 259.00), (9, 9, '2026-05-12', 359.00),
(10, 1, '2026-05-28', 459.00), (11, 3, '2026-06-01', 519.00), (12, 5, '2026-06-02', 629.00),
(13, 7, '2026-06-05', 739.00), (1, 9, '2026-06-07', 849.00);
go

-- Actualizar precios o montos de ventas según una condición
update TVenta set nMontoTotal = nMontoTotal * 0.95 where dFechaVenta < '2026-04-01';
go

-- Eliminar clientes sin ventas
delete from TCliente where nClienteID not in (select distinct nClienteID from TVenta);
go

-- Consultar los 5 clientes con mayores compras
select top 5 c.nClienteID, c.cNombre, c.cApellido, sum(v.nMontoTotal) as TotalCompras
from TCliente c
join TVenta v on c.nClienteID = v.nClienteID
group by c.nClienteID, c.cNombre, c.cApellido
order by TotalCompras desc;
go

-- Consultar ventas por mes
select year(dFechaVenta) as Anio, month(dFechaVenta) as Mes, sum(nMontoTotal) as TotalVentas, count(*) as CantidadVentas
from TVenta
group by year(dFechaVenta), month(dFechaVenta)
order by Anio, Mes;
go

-- Consultar promedio de ventas por cliente
select c.nClienteID, c.cNombre, c.cApellido, avg(v.nMontoTotal) as PromedioVenta
from TCliente c
join TVenta v on c.nClienteID = v.nClienteID
group by c.nClienteID, c.cNombre, c.cApellido;
go

-- Generar un reporte consolidado utilizando JOIN entre tres tablas
select v.nVentaID, c.cNombre as NombreCliente, c.cApellido as ApellidoCliente, e.cNombre as NombreEmpleado, v.dFechaVenta, v.nMontoTotal
from TVenta v
join TCliente c on v.nClienteID = c.nClienteID
left join TEmpleado e on v.nEmpleadoID = e.nEmpleadoID;
go


-- =================================================================================
-- Parte VII. Administración de Objetos
-- =================================================================================

-- Eliminar la restricción CHECK de edad
alter table TEmpleado drop constraint CK_TEmpleado_Edad;
go

-- Eliminar la restricción UNIQUE del correo
alter table TEmpleado drop constraint UQ_TEmpleado_Email;
go

-- Agregar nuevamente ambas restricciones
alter table TEmpleado add constraint CK_TEmpleado_Edad check (nEdad between 18 and 65);
alter table TEmpleado add constraint UQ_TEmpleado_Email unique (cEmail);
go



-- Comandos de eliminación estructurados y comentados


-- Eliminar la tabla TEmpleadoProyecto
-- drop table TEmpleadoProyecto;
-- go

-- Eliminar la tabla TProyecto
-- drop table TProyecto;
-- go

-- Eliminar la tabla TVenta
-- drop table TVenta;
-- go

-- Eliminar la tabla TCliente
-- drop table TCliente;
-- go

-- Eliminar la tabla TEmpleado
-- drop table TEmpleado;
-- go

-- Eliminar la tabla TCargo
-- drop table TCargo;
-- go

-- Eliminar la tabla TDepartamento
-- drop table TDepartamento;
-- go

-- Eliminar la tabla TSucursal
-- drop table TSucursal;
-- go

-- Eliminar la base de datos EmpresaSQL
-- use master;
-- drop database EmpresaSQL;
-- go