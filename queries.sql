create database testDatabase

use testDatabase

create table Brands(
	Id int primary key identity,
	Name nvarchar(50) not null
)

create table Notebooks(
 Id int primary key identity,
 Name nvarchar(50) not null,
 Price decimal(10,1) check(Price>=0),
 BrandId int foreign key references Brands(Id)
)


select n.Name as Notebook, b.Name as Brand, n.Price from Notebooks n
join Brands b
on n.BrandId = b.Id
where b.Name Like '%a'


select Name as Notebook , Price from Notebooks
where (Price between 100 and 500) or Price>=900


select b.Name as Brand,  Count(n.Name) as 'Product Count' from Notebooks n
join Brands b
on n.BrandId = b.Id
Group by b.Name
Having Count(n.Name)>2
order by b.Name desc



create table Phones(
	Id int primary key identity,
	Name nvarchar(50),
	Price decimal(10,1),
	BrandId int foreign key references Brands(Id)
)


insert into Phones(Price,Name,BrandId)
values(1000,'Model 1',2),
(900,'Model 11',2),
(800,'Model 2',1),
(850,'Model 12',1),
(600,'Model 9',3),
(300,'Model 15',3),
(1200,'Model 16',4),
(1300,'Model 17',4)

select * from Notebooks
union all
select * from Phones


select Brand, Count(Brand) as 'Product count' from
(select n.Name as Model, n.Price as 'Price', b.Name as Brand from Notebooks as n
join Brands b
on n.BrandId = b.Id
union all
select p.Name as Model, p.Price as 'Price', b.Name as Brand from Phones as p
join Brands b
on b.Id = p.BrandId
) as PhoneNoteBook
Group by Brand



create table Department(
	Id int primary key identity,
	Name nvarchar(50),
	DepartmentId int
)

insert into Department(Name)
values('Finance'),
('Accounting'),
('Risk Managment'),
('Managment of leasing'),
('Investment and project managment'),
('Rebuilding of physically damaged infrastructure')


select Main.Name as Main, Sub.Name as Sub from Department as Main
left join Department as Sub
on Main.Id = Sub.DepartmentId


select * from
(select n.Name as Model, n.Price as 'Price', b.Name as Brand from Notebooks as n
join Brands b
on n.BrandId = b.Id
union all
select p.Name as Model, p.Price as 'Price', b.Name as Brand from Phones as p
join Brands b
on b.Id = p.BrandId
) as PhoneNoteBook



create view vw_selectAllProducts
as
select * from
(select n.Name as Model, n.Price as 'Price', b.Name as Brand from Notebooks as n
join Brands b
on n.BrandId = b.Id
union all
select p.Name as Model, p.Price as 'Price', b.Name as Brand from Phones as p
join Brands b
on b.Id = p.BrandId
) as PhoneNoteBook


select * from vw_selectAllProducts
where Price >=700


select * from vw_selectAllProducts
where Price>=900



select * from vw_selectAllProducts
where Price>=1200


select * from vw_selectAllProducts
where Model like '%o%'


create procedure usp_selectAllProductsWithprice
@Price decimal(10,1)
as
select * from vw_selectAllProducts
where Price>=@Price

exec usp_selectAllProductsWithprice 300


create procedure usp_selectProductsWithLetter
@Letter nvarchar(15)
as
select * from vw_selectAllProducts
Where Model like '%' + @Letter + '%'


exec usp_selectProductsWithLetter 'Model 2'

create procedure usp_selectProductsWithPriceAndLetters
@Price int = 0,
@Letter nvarchar(15)
as
select * from vw_selectAllProducts 
where Model like '%' + @Letter + '%' and Price>=@Price 


exec usp_selectProductsWithPriceAndLetters @Letter= '1'

alter procedure usp_selectProductsWithPriceAndLetters
@Price int = 0,
@Letter nvarchar(15) = ''
as
select * from vw_selectAllProducts 
where Model like '%' + @Letter + '%' and Price>=@Price 

exec usp_selectProductsWithPriceAndLetters @Letter = '1', @Price = 1200


create procedure usp_deleteProduct
@Name nvarchar(15) = ''
as
delete from Notebooks
where Name = @Name

exec usp_deleteProduct 'Model 1'


create procedure usp_addNotebook
@Name nvarchar(30) ,
@Price decimal (10,1),
@BrandId int
as
insert into Notebooks(Name, Price, BrandId)
values(@Name,@Price,@BrandId)



exec usp_addNotebook 'Model 1', 1200.9, 1


create procedure usp_updateNotebookData
@Price decimal (10,1),
@Id int
as
update Notebooks
set Price = @Price
where Id = @Id


exec usp_updateNotebookData @Id = 7, @Price = 10000.9

create table Users(
	Id int primary key identity,
	Name nvarchar(30),
	Surname nvarchar(30)
)

--drop table Users

create function fn_cutName(@Name nvarchar(30),@Surname nvarchar(30))
returns nvarchar(30)
as
begin
	return Substring(@Name,1,1)+ '.'+@Surname 
end


select dbo.fn_cutName(Name,Surname) from Users