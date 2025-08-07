SELECT * FROM alex_the_analyst.layoffs;
select * from layoffs;

create table layoffs_staging like layoffs;
insert into layoffs_staging select* from layoffs;
select * from layoffs_staging;



-- Remove dups
-- long process in mysql


with duplicate_cte as
(
select *,
 row_number() over(partition by company, location, industry,total_laid_off, `date`, stage, country, funds_raised_millions ) as tymofoccurence
from layoffs_staging
)
select * from duplicate_cte where tymofoccurence > 1;

select * from layoffs_staging where company = "Casper"; 	
-- delete from duplicate_cte where tymofoccurence > 1;  yeh query nai chalegi coz delete is also an update statement also,, idhar duplicate_cte table column mei exist hi nai hora
 
CREATE TABLE `layoffs_staging 2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `tymofoccurence` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from `layoffs_staging 2`;

insert into `layoffs_staging 2`
select *,
 row_number() over(partition by company, location, industry,total_laid_off, `date`, stage, country, funds_raised_millions ) as tymofoccurence
from layoffs_staging;
-- delete redundancies
-- SET SQL_SAFE_UPDATES = 0; kyuki safe mode on thaa
delete from `layoffs_staging 2` where tymofoccurence>1; -- challo abhi redundacies hatt gayi hai and final table is layoffs_staging 2 






-- stardize data and nulls

 select company from `layoffs_staging 2`;-- notice space b4 E Inc
 select company, trim(company) from `layoffs_staging 2`;
-- aa sidhu main table update kari nakse--> update `layoffs_staging 2` set company = trim(company);
-- what if beo rakhva che for a comparision(generally preferred nathi kemke redundancy vadhse but you need it initially to see ke gaflo toh nai thai gayo ne bhul thii)
SELECT company, TRIM(company) AS company_trimmed
FROM `layoffs_staging 2`;-- checking stage..ana pachi bhalene you put an update clause 

select distinct industry from `layoffs_staging 2` order by industry asc; -- notice crypto,CryptoCurrency, crypto currency alag alag consider kare check table
-- same with hr and recruitment, travel and transportation etc etc. Also aaya order by 1 pan chalsee!

select * from `layoffs_staging 2` where industry like 'crypto%';-- observe that mostly crypto che.. khali 2-3 ma cryptocurrency che. toh chalo badhu sarkhu karo

update `layoffs_staging 2` set industry = 'Crypto' where industry like 'crypto%' or industry like 'Crypto%';
update `layoffs_staging 2` set industry = 'HR' where industry like 'Recruiting';

select distinct location from `layoffs_staging 2` order by 1;-- sabb sahi hai
select distinct country from `layoffs_staging 2` order by 1;-- us ka dekh
update `layoffs_staging 2` set country = 'United States' where country like 'United States.'; -- trailing pan use thai trim(trailing'.' from country)

 -- date prakran
 SELECT DATE FROM`layoffs_staging 2`;
 select date, STR_TO_DATE(DATE,'%m/%d/%Y') FROM `layoffs_staging 2`;
 update `layoffs_staging 2` set date = STR_TO_DATE(DATE,'%m/%d/%Y');

alter table `layoffs_staging 2` modify column `date` date;

select * from `layoffs_staging 2` where company = 'Airbnb'; -- look how industry is empty in few records
-- SOMETIMES IT MAY HAPPEN THAT THE VALUES ARE NULL / EMPTY. ABHI DONO KO ALAG ALAG KARNE SE ACHA HAI KE EKK HI BAAR MEI SAB ACHESE KHATAM KARO
-- AND FOR THAT WE HAVE TO CONVERT ALL INTO NULLS FIRST
update `layoffs_staging 2` set industry = null where industry = '';
select * from `layoffs_staging 2` where industry is null; 

select t1.industry, t2.industry from `layoffs_staging 2` t1 join `layoffs_staging 2` t2 on 
t1.company=t2.company -- amuk amuk ma discrepancy dekhase 
where t1.industry is null and t2.industry is not null;

update `layoffs_staging 2` t1
join `layoffs_staging 2` t2
on t1.company=t2.company
set t1.industry = t2.industry
where t1.industry is null and t2.industry is not null; 

-- bhaii saab ekk galti ki vajeh se pura table duplicate ho gya chalo dusri tarha se thik karte hai
-- select * from `layoffs_staging 2`;
-- SELECT *
-- FROM `layoffs_staging 2`
-- GROUP BY `date`, company, location, industry, total_laid_off, percentage_laid_off, `country`, stage, funds_raised_millions,tymofoccurence
-- HAVING COUNT(*) > 1;-- 
-- CREATE TABLE temp_unique_rows AS
-- SELECT * 
-- FROM `layoffs_staging 2`
-- GROUP BY `date`, company, location, industry, total_laid_off, percentage_laid_off, `country`, stage, funds_raised_millions, tymofoccurence;

-- SELECT * 
-- FROM `layoffs_staging 2`;-- 4712 records
-- TRUNCATE TABLE `layoffs_staging 2`;
-- INSERT INTO `layoffs_staging 2`
-- SELECT * FROM temp_unique_rows;
-- drop table temp_unique_rows;

select * from `layoffs_staging 2` where industry is null;-- salli bally ma kaik goto che
select * from `layoffs_staging 2` where company = 'Bally\'s Interactive';-- cant do anything kemke ekk aj row che. we dont know ke uska industry kya hai



-- remove unnecessary data

select * from `layoffs_staging 2` where tymofoccurence>1;

alter table `layoffs_staging 2`
drop column tymofoccurence; 

-- ta daaa