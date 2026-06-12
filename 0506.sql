
-- módulo i & ii - creación de base de datos, tablas y restricciones


if not exists (select * from sys.databases where name = 'HospitalDB')
begin
    create database HospitalDB;
end
go

-- 2. mostrar todas las bases de datos existentes
select name from sys.databases;
go

-- 3. seleccionar hospitaldb
use HospitalDB;
go

-- 4. tabla pacientes (incluye req 11, 13, 15, 17, 19)
if not exists (select * from sys.tables where name = 'Pacientes')
begin
    create table Pacientes(
        id_paciente int identity(1,1),
        nombre_paciente varchar(50) not null,
        correo_paciente varchar(50) not null,
        edad_paciente int,
        fecha_registro datetime constraint df_pacientes_fechareg default getdate(),
        
        constraint pk_pacientes primary key (id_paciente),
        constraint uq_pacientes_correo unique (correo_paciente),
        constraint ck_pacientes_edad check (edad_paciente >= 0)
    );
end 
go

-- 6. tabla especialidades
if not exists (select * from sys.tables where name = 'Especialidades')
begin
    create table Especialidades(
        id_especialidad int identity(1,1),
        nombre_especialidad varchar(60) not null,
        constraint pk_especialidades primary key (id_especialidad),
        constraint uq_especialidades_nombre unique (nombre_especialidad)
    );
end
go

-- 5. tabla medicos (incluye req 12, 14, 16, 18, 20)
if not exists (select * from sys.tables where name = 'Medicos')
begin
    create table Medicos(
        id_medico int identity(1,1),
        nombre_medico varchar(50) not null,
        correo_medico varchar(50) not null,
        salario_Medico int,
        id_especialidad int, -- necesario para la fk
        
        constraint pk_medicos primary key (id_medico),
        constraint uq_medicos_correo unique (correo_medico),
        constraint ck_medicos_salario check (salario_Medico > 0),
        constraint fk_medicos_especialidades foreign key (id_especialidad) references Especialidades(id_especialidad)
    );
end
go

-- 7. tabla citas (incluye req 21, 22)
if not exists (select * from sys.tables where name = 'Citas')
begin
    create table Citas(
        id_cita int identity(1,1),
        id_paciente int not null,
        id_medico int not null,
        fecha_cita datetime not null,
        motivo_cita varchar(60) not null,
        
        constraint pk_citas primary key (id_cita),
        constraint fk_citas_pacientes foreign key (id_paciente) references Pacientes(id_paciente),
        constraint fk_citas_medicos foreign key (id_medico) references Medicos(id_medico)
    );
end
go

-- 8. tabla habitaciones (incluye req 25)
if not exists (select * from sys.tables where name = 'Habitaciones')
begin
    create table Habitaciones(
        id_habitacion int identity(1,1),
        numero_habitacion int not null,
        tipo_habitacion varchar(30) not null,
        id_paciente int null, -- necesario para vincular al paciente asignado
        
        constraint pk_habitaciones primary key (id_habitacion),
        constraint uq_habitaciones_numero unique (numero_habitacion),
        constraint fk_habitaciones_pacientes foreign key (id_paciente) references Pacientes(id_paciente)
    );
end
go

-- 9. tabla tratamientos (incluye req 23)
if not exists (select * from sys.tables where name = 'Tratamientos')
begin
    create table Tratamientos(
        id_tratamiento int identity(1,1),
        id_paciente int not null,
        id_medico int not null,
        descripcion_tratamiento varchar(300) not null,
        fecha_inicio datetime not null,
        fecha_fin datetime not null,
        
        constraint pk_tratamientos primary key (id_tratamiento),
        constraint fk_tratamientos_pacientes foreign key (id_paciente) references Pacientes(id_paciente),
        constraint fk_tratamientos_medicos foreign key (id_medico) references Medicos(id_medico)
    );
end
go

-- 10. tabla medicamentos (incluye req 24)
if not exists (select * from sys.tables where name = 'Medicamentos')
begin
    create table Medicamentos(
        id_medicamento int identity(1,1),
        nombre_medicamento varchar(50) not null,
        dosis varchar(300) not null,
        id_tratamiento int null, -- necesario para la fk
        fecha_vencimiento date null, -- necesario para el módulo vii
        
        constraint pk_medicamentos primary key (id_medicamento),
        constraint uq_medicamentos_nombre unique (nombre_medicamento),
        constraint fk_medicamentos_tratamientos foreign key (id_tratamiento) references Tratamientos(id_tratamiento)
    );
end
go



-- módulo iii - modificación de estructuras (alter)


-- 26 a 30. columnas nuevas en pacientes
alter table Pacientes add telefono varchar(15) null;
alter table Pacientes add direccion varchar(100) null;
alter table Pacientes add genero varchar(10) null;
alter table Pacientes add tipo_sangre varchar(5) null;
alter table Pacientes add fecha_nacimiento datetime null;
go

-- columna temporal para cumplir el borrado del módulo iv sin romper "telefono"
alter table Pacientes add columna_prueba varchar(10) null; 
go

-- 31 y 32. modificar tamaños
alter table Pacientes alter column nombre_paciente varchar(100) not null;
alter table Pacientes alter column direccion varchar(150) null;
go

-- 33 a 35. columnas en médicos
alter table Medicos add experiencia int null;
go
alter table Medicos add constraint ck_medicos_experiencia check(experiencia >= 0);
go
alter table Medicos add turno varchar(20) null;
alter table Medicos add observaciones varchar(300) null;
go

-- 36. eliminar observaciones
alter table Medicos drop column observaciones;
go

-- 37 y 38. columnas en citas (costo se agrega temporalmente como int para cambiar tipo luego)
alter table Citas add estado varchar(20) null;
alter table Citas add costo_consulta int null; 
go

-- 39. modificar tipo de dato del costo y agregar su check de forma correcta
alter table Citas alter column costo_consulta decimal(10,2) null;
go
alter table Citas add constraint ck_citas_costo check(costo_consulta > 0);
go

-- 40. columna disponibilidad en habitaciones
alter table Habitaciones add disponibilidad bit null;
go



-- módulo iv - eliminación de objetos (drop)


-- 41. eliminar una tabla temporal (creación y eliminación de ejemplo)
create table #TempTable (id int);
drop table #TempTable;
go

-- 42. eliminar restricción check creada con nombre explícito
alter table Pacientes drop constraint ck_pacientes_edad;
go

-- 43. eliminar restricción unique creada con nombre explícito
alter table Pacientes drop constraint uq_pacientes_correo;
go

-- 44. eliminar una columna (eliminamos la de prueba para preservar el teléfono)
alter table Pacientes drop column columna_prueba;
go

-- 45. eliminar una tabla de pruebas
if object_id('TablaPrueba') is not null drop table TablaPrueba;
go

-- 46. crear y eliminar tabla auditoria
create table Auditoria (id int, accion varchar(50));
drop table Auditoria;
go

-- 47. crear y eliminar tabla logs
create table Logs (id int identity, detalle varchar(50), fecha datetime);
insert into Logs (detalle, fecha) values ('Prueba', dateadd(month, -7, getdate()));
drop table Logs;
go

-- 48. eliminar una foreign key de ejemplo y remapear
alter table Habitaciones drop constraint fk_habitaciones_pacientes;
alter table Habitaciones add constraint fk_habitaciones_pacientes foreign key (id_paciente) references Pacientes(id_paciente);
go

-- 49. eliminar tabla medicamentosprueba
if object_id('MedicamentosPrueba') is not null drop table MedicamentosPrueba;
go

-- 50. eliminar base de datos de pruebas
if exists (select * from sys.databases where name = 'BaseDatosPrueba')
begin
    alter database BaseDatosPrueba set single_user with rollback immediate;
    drop database BaseDatosPrueba;
end
go



-- módulo v - inserts (datos completos requeridos por la guía)


-- 51. 5 especialidades
insert into Especialidades(nombre_especialidad) values 
('Cardiología'), ('Neurología'), ('Pediatría'), ('Dermatología'), ('Gastroenterología');
go

-- 52 & 59. 10 médicos especialistas
insert into Medicos(nombre_medico, correo_medico, salario_Medico, experiencia, turno, id_especialidad) values 
('Dr. Luis Montenegro', 'lm@gmail.com', 5000, 10, 'Mañana', 1),
('Dra. Ana Martinez','am@gmail.com', 5500, 8, 'Tarde', 2),
('Dr. Carlos Meza','cm@gmail.com', 6000, 15, 'Noche', 3),
('Dra. Sofia Ramirez','sm@gmail.com', 5200, 12, 'Mañana', 4),
('Dr. Juan Garcia','jg@gmail.com', 4800, 5, 'Tarde', 5),
('Dra. Laura Torres','lt@gmail.com', 5300, 9, 'Noche', 1),
('Dr. Pedro Sanchez','ps@gmail.com', 6200, 20, 'Mañana', 2),
('Dra. Maria Lopez','ml@gmail.com', 5100, 7, 'Tarde', 3),
('Dr. Andres Gomez','ag@gmail.com', 5800, 14, 'Noche', 4),
('Dra. Elena Diaz','ed@gmail.com', 5400, 11, 'Mañana', 5);
go

-- 53 & 58. 20 pacientes completo
insert into Pacientes(nombre_paciente, correo_paciente, edad_paciente, direccion, genero, tipo_sangre, fecha_nacimiento, telefono) values 
('Juan Perez', 'jp@gmail.com', 30, 'Calle 123', 'Masculino', 'O+', '1993-05-15', '555-1111'),
('Maria Salgado', 'ms@gmail.com', 25, 'Avenida 456', 'Femenino', 'A+', '1998-08-22', '555-2222'),
('Rommel Muñoz', 'rm@gmail.com', 40, 'Boulevard 789', 'Masculino', 'B+', '1983-11-30', '555-3333'),
('Sofia Torres', 'st@gmail.com', 35, 'Calle 321', 'Femenino', 'AB+', '1988-02-10', '555-4444'),
('Jose Duran', 'jdg@gmail.com', 28, 'Avenida 654', 'Masculino', 'O+', '1944-03-19', '555-5555'),
('Ana Gutierrez', 'agut@gmail.com', 19, 'Leon', 'Femenino', 'O-', '2007-01-01', '555-0001'),
('Luis Blandon', 'lblan@gmail.com', 45, 'Managua', 'Masculino', 'A-', '1981-05-12', '555-0002'),
('Marcos Altamirano', 'malt@gmail.com', 60, 'Esteli', 'Masculino', 'O+', '1966-07-20', '555-0003'),
('Elena Rostran', 'eros@gmail.com', 32, 'Masaya', 'Femenino', 'B+', '1994-02-14', '555-0004'),
('Sonia Pastora', 'spas@gmail.com', 23, 'Granada', 'Femenino', 'AB-', '2003-11-11', '555-0005'),
('Roberto Gomez', 'rgom@gmail.com', 51, 'Rivas', 'Masculino', 'O+', '1975-09-05', '555-0006'),
('Clara Sevilla', 'csev@gmail.com', 27, 'Chinandega', 'Femenino', 'A+', '1999-04-18', '555-0007'),
('Daniel Ortega', 'dort@gmail.com', 38, 'Matagalpa', 'Masculino', 'B-', '1988-12-25', '555-0008'),
('Patricia Zeledon', 'pzel@gmail.com', 42, 'Jinotega', 'Femenino', 'O+', '1984-03-30', '555-0009'),
('Fernando Rios', 'frios@gmail.com', 55, 'Boaco', 'Masculino', 'AB+', '1971-06-14', '555-0010'),
('Gabriela Nuñez', 'gnuz@gmail.com', 22, 'Juigalpa', 'Femenino', 'A+', '2004-10-02', '555-0011'),
('Hugo Castellon', 'hcast@gmail.com', 33, 'Somoto', 'Masculino', 'O-', '1993-08-21', '555-0012'),
('Irene Mendoza', 'imen@gmail.com', 29, 'Ocotal', 'Femenino', 'B+', '1997-01-15', '555-0013'),
('Jorge Herrera', 'jherr@gmail.com', 48, 'Bluefields', 'Masculino', 'O+', '1978-05-19', '555-0014'),
('Lucia Solorzano', 'lsol@gmail.com', 31, 'Bilwi', 'Femenino', 'A-', '1995-07-07', '555-0015');
go

-- 54, 60 & 61. 15 citas (fechas actuales y futuras)
insert into Citas(id_paciente, id_medico, fecha_cita, motivo_cita, estado, costo_consulta) values 
(1, 1, getdate(), 'Control mensual', 'Pendiente', 50.00),
(2, 2, getdate(), 'Dolor de cabeza', 'Pendiente', 60.00),
(3, 3, dateadd(day, 2, getdate()), 'Chequeo general', 'Pendiente', 45.00),
(4, 4, dateadd(day, 5, getdate()), 'Problema de piel', 'Pendiente', 70.00),
(5, 5, getdate(), 'Dolor estomacal', 'Pendiente', 55.00),
(6, 6, getdate(), 'Examen del corazón', 'Pendiente', 80.00),
(7, 7, dateadd(day, 1, getdate()), 'Consulta Neurología', 'Pendiente', 90.00),
(8, 8, dateadd(day, 3, getdate()), 'Control Pediatría', 'Pendiente', 40.00),
(9, 9, getdate(), 'Tratamiento Acné', 'Pendiente', 65.00),
(10, 10, dateadd(day, 4, getdate()), 'Endoscopia', 'Pendiente', 120.00),
(11, 1, getdate(), 'Revisión presión', 'Pendiente', 50.00),
(12, 2, dateadd(day, 7, getdate()), 'Migraña crónica', 'Cancelada', 60.00),
(13, 3, getdate(), 'Consulta general', 'Pendiente', 45.00),
(14, 4, dateadd(day, 6, getdate()), 'Alergia severa', 'Pendiente', 70.00),
(15, 5, getdate(), 'Reflujo gástrico', 'Pendiente', 55.00);
go

-- 55, 62 & 63. 10 habitaciones (disponibles u ocupadas)
insert into Habitaciones(numero_habitacion, tipo_habitacion, id_paciente, disponibilidad) values 
(101, 'Individual', 1, 0),
(102, 'Compartida', null, 1),
(103, 'Suite', 2, 0),
(104, 'Individual', null, 1),
(105, 'Compartida', 3, 0),
(201, 'Individual', null, 1),
(202, 'Suite', null, 1),
(203, 'Compartida', 4, 0),
(204, 'Individual', null, 1),
(205, 'Suite', null, 1);
go

-- 56, 64 & 65. 10 tratamientos (activos y finalizados)
insert into Tratamientos(id_paciente, id_medico, descripcion_tratamiento, fecha_inicio, fecha_fin) values 
(1, 1, 'Tratamiento inicial hipertensión', getdate(), dateadd(month, 3, getdate())),
(2, 2, 'Terapia migraña severa', getdate(), dateadd(month, 1, getdate())),
(3, 3, 'Reposo y dieta balanceada', dateadd(month, -2, getdate()), dateadd(month, -1, getdate())),
(4, 4, 'Pomada dermatológica diaria', getdate(), dateadd(day, 15, getdate())),
(5, 5, 'Antibióticos infección estomacal', dateadd(day, -7, getdate()), dateadd(day, -1, getdate())),
(6, 6, 'Seguimiento post-operatorio', getdate(), dateadd(month, 6, getdate())),
(7, 7, 'Rehabilitación neurológica', getdate(), dateadd(month, 2, getdate())),
(8, 8, 'Vitaminas desarrollo infantil', dateadd(month, -1, getdate()), getdate()),
(9, 9, 'Tratamiento láser para acné', getdate(), dateadd(week, 4, getdate())),
(10, 10, 'Dieta líquida pre-quirúrgica', getdate(), dateadd(day, 3, getdate()));
go

-- 57. 20 medicamentos
insert into Medicamentos(nombre_medicamento, dosis, id_tratamiento, fecha_vencimiento) values 
('Paracetamol', '500mg cada 8 horas', 2, '2027-12-01'),
('Ibuprofeno', '400mg con las comidas', 2, '2024-01-01'), -- vencido para probar delete
('Amoxicilina', '500mg cada 8 horas', 5, '2027-05-15'),
('Omeprazol', '20mg antes del desayuno', 5, '2028-02-28'),
('Losartan', '50mg una vez al día', 1, '2027-10-10'),
('Metformina', '850mg con la cena', null, '2027-08-20'),
('Atorvastatina', '20mg en la noche', null, '2026-11-12'),
('Aspirina', '100mg diarios', 1, '2023-05-01'), -- vencido
('Clonazepam', '0.5mg bajo receta', 7, '2027-03-14'),
('Loratadina', '10mg cada 24 horas', 4, '2028-01-01'),
('Diclofenaco', '75mg inyectable', null, '2027-06-18'),
('Sertralina', '50mg en las mañanas', null, '2027-09-05'),
('Fluconazol', '150mg dosis única', null, '2028-04-22'),
('Enalapril', '10mg cada 12 horas', 1, '2027-07-19'),
('Ranitidina', '150mg por las noches', null, '2024-06-01'), -- vencido
('Cetirizina', '10mg al acostarse', 4, '2028-05-10'),
('Metoclopramida', '10mg antes de comer', 10, '2027-11-30'),
('Salbutamol', '2 inhalaciones si hay crisis', null, '2028-09-09'),
('Insulina NPH', 'Según esquema', null, '2027-02-15'),
('Complejo B', '1 tableta diaria', 8, '2028-03-03');
go



-- módulo vi - updates


-- 66 a 80. actualizaciones puntuales utilizando ids reales cargados previamente
update Pacientes set telefono = '555-9999' where id_paciente = 1;
update Pacientes set direccion = 'Calle Nueva 456' where id_paciente = 2;
update Medicos set salario_Medico = 6000 where id_medico = 1;
update Medicos set turno = 'Tarde' where id_medico = 2;
update Citas set estado = 'Confirmada' where id_cita = 1;
update Citas set costo_consulta = 150.00 where id_cita = 2;
update Especialidades set nombre_especialidad = 'Cardiología Avanzada' where id_especialidad = 1;
update Habitaciones set disponibilidad = 0 where id_habitacion = 2;
update Tratamientos set descripcion_tratamiento = 'Tratamiento activo para hipertensión severa' where id_tratamiento = 1;
update Medicamentos set dosis = 'Tomar una pastilla cada 12 horas' where id_medicamento = 1;
update Pacientes set correo_paciente = 'nuevo_rommel@gmail.com' where id_paciente = 3;
update Medicos set correo_medico = 'lmmnegro@gmail.com' where id_medico = 1;
update Citas set fecha_cita = '2026-07-01 10:00:00' where id_cita = 1;
update Medicos set experiencia = 12 where id_medico = 1;
update Pacientes set tipo_sangre = 'A-' where id_paciente = 4;
go



-- módulo vii - delete


-- 81 a 85. eliminación controlada de registros específicos sin romper integridad
delete from Medicamentos where id_medicamento = 13; -- medicamento sin relación activa
delete from Habitaciones where id_habitacion = 4; -- habitación libre número 104
delete from Citas where id_cita = 15;
delete from Tratamientos where id_tratamiento = 3;
delete from Pacientes where id_paciente = 20; -- paciente sin dependencias directas
go

-- 86. eliminar citas canceladas
delete from Citas where estado = 'Cancelada';
go

-- 87. eliminar pacientes sin citas asignadas
delete from Pacientes where id_paciente not in (select distinct id_paciente from Citas);
go

-- 88. eliminar habitaciones vacías y disponibles
delete from Habitaciones where disponibilidad = 1 and id_paciente is null;
go

-- 89. eliminar medicamentos vencidos comparando con la fecha actual
delete from Medicamentos where fecha_vencimiento < getdate();
go

-- 90. eliminar registros de prueba (control preventivo por tabla log eliminada en módulo iv)
if object_id('Logs') is not null
begin
    delete from Logs where fecha < dateadd(month, -6, getdate());
end
go



-- módulo viii - consultas select

-- 91. mostrar todos los pacientes
select * from Pacientes;

-- 92. mostrar todos los médicos
select * from Medicos;

-- 93. mostrar todas las especialidades
select * from Especialidades;

-- 94. mostrar todas las citas
select * from Citas;

-- 95. mostrar pacientes ordenados por su nombre
select * from Pacientes order by nombre_paciente asc;

-- 96. mostrar médicos ordenados por salario de forma descendente
select * from Medicos order by salario_Medico desc;

-- 97. mostrar citas del día actual
select * from Citas where cast(fecha_cita as date) = cast(getdate() as date);

-- 98. mostrar habitaciones disponibles
select * from Habitaciones where disponibilidad = 1;

-- 99. mostrar cantidad de pacientes registrados
select count(*) as Cantidad_Pacientes from Pacientes;

-- 100. mostrar cantidad de citas por médico
select id_medico, count(*) as Cantidad_Citas from Citas group by id_medico;
go