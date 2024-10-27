--Exercise 1

select d.name,

--To get the name of the blood type for the donor
(select b.name 
from blood_types b 
where b.blood_type_id = d.blood_type_id
) as blood_type,

--To get the donation date and approved quantity for the doner
dt.donation_date,dt.approved_quantity,

--To get the name of the doctor supervising the donor
(select do.name 
from employee do where do.employee_id=dt.doctor_id
) as doctor,

--To get the name of the receptionist supervising the donor
(select re.name 
from employee re where re.employee_id=dt.reseption_id
)as reseption

from doners d 
Inner Join donation dt 
on d.doner_id = dt.doner_id 
order by name ;

----------------------------------------------------------------
--Exercise 2
select name ,order_id,order_date ,

--To get the name of the blood type for order
(select b.name 
from blood_types b 
where b.blood_type_id = o.blood_type_id
) as blood_type,

--To get quantity_ordered and quantity_supplied for the each order
quantity_ordered , quantity_supplied

from hospitals h 
Inner Join blood_orders o 
--Adding a condition that the quantity ordered does not equal the quantity supplied
on (h.hospital_id = o.hospital_id and o.quantity_ordered != o.quantity_supplied) 
order by name;

--------------------------------------------------------------
--Exercise 3
select t1.name from 

--Find people who have donated more than five times
(select name , do.doner_id counts 
from doners d 
Inner Join donation do  
on (d.doner_id=do.doner_id)
group by name,do.doner_id
having COUNT(*) >=5 ) t1  

--Find people whose donation was rejected once
Inner Join 
(select name,d.doner_id counts from doners d 
Inner Join donation do  
on (d.doner_id=do.doner_id)
group by name ,
d.doner_id,do.doner_id,approved_quantity
having count(*) = 1 and approved_quantity = 0) t2 
on (t1.counts=t2.counts)


---------------------------------------------------
--Exercise 4
--Finding requests for all hospitals that requested O- blood group
select * from(
select name,quantity_supplied,type_id from hospitals t2 
Inner Join blood_orders o 
on (t2.hospital_id=o.hospital_id)
) a

Inner Join
--Finding the highest order for a government hospital

(select max( o.quantity_supplied )as highest_quantity from
(select hospital_id from hospitals 
where type_id=1) t1 
Inner Join blood_orders o 
on t1.hospital_id = o.hospital_id
) b 

--Comparison between the highest order and orders of private hospitals
on a.quantity_supplied> b.highest_quantity



-------------------------------------------------------------------------
--Exercise 5

create table blood_orders2(
order_id int not null,
blood_type_id int not null,
hospital_id int  not null,
quantity_supplied int not null,
quantity_ordered int not null,
order_date date not null ,
constraint orders_pk primary key(order_id),
constraint blood_orders_fk foreign key(blood_type_id) 
references blood_types(blood_type_id),
constraint hospital_orders_fk foreign key(hospital_id) 
references hospitals(hospital_id)
);








