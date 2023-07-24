-- Data Cleaning

Select * 
from SQLProject.nashvillehousing;

-- updating date column covert from 2-Apr-2020 to 4-2-2022
UPDATE SQLProject.nashvillehousing
SET Saledate = DATE_FORMAT(STR_TO_DATE(Saledate, '%m/%e/%Y'), '%c-%e-%Y');

-- Modify Property address
select
	sum(CASE When PropertyAddress IS NULL Then 1 else 0 End) as no_of_null
from SQLProject.nashvillehousing; -- there are 29 null values for property address

-- ParcelID and PropertyAddress are same most of the time, so we can populate that values for property address based on ParcelID
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from SQLProject.nashvillehousing a
join SQLProject.nashvillehousing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.ParcelID
where a.PropertyAddress is null;

UPDATE SQLProject.nashvillehousing a
JOIN SQLProject.nashvillehousing b 
	ON a.ParcelID = b.ParcelID 
    AND a.UniqueID <> b.UniqueID
SET a.propertyaddress = COALESCE(a.propertyaddress, b.propertyaddress)
WHERE a.propertyaddress IS NULL;

-- working on property address to seperate address, city 
-- SUBSTRING_INDEX(str, delim, count)

Alter table SQLProject.nashvillehousing
add Street varchar(100), 
add	City varchar(100);

update SQLProject.nashvillehousing
set Street = SUBSTRING_INDEX(PropertyAddress, ',', 1),
    City = SUBSTRING_INDEX(Propertyaddress, ',', -1);
    
Alter table SQLProject.nashvillehousing
drop column propertyaddress;

ALTER TABLE SQLProject.nashvillehousing
CHANGE Street Propertystreet VARCHAR(100),
CHANGE city Propertycity VARCHAR(100);


-- working on Owner address to seperate address, city, State
-- populate the null values of owner using proprty address
select
	sum(CASE When owneraddress IS NULL Then 1 else 0 End) as no_of_null
from SQLProject.nashvillehousing; -- there are 30456 null values for property address

Alter table SQLProject.nashvillehousing
add Ownerstreet varchar(100), 
add	Ownercity varchar(100),
add Ownerstate varchar(50);

update SQLProject.nashvillehousing
set Ownerstreet = SUBSTRING_INDEX(owneraddress, ',', 1), -- everthing before first ,
    Ownercity = SUBSTRING_INDEX(SUBSTRING_INDEX(owneraddress, ',', 2), ',', -1), --  first everything before second , and use -1 to get everything after lst ,
    Ownerstate = SUBSTRING_INDEX(owneraddress, ',', -1);-- everything after last ,


-- change Y and N to yes and no in soldasvacant

select distinct(soldasvacant), count(SoldAsVacant)
from SQLProject.nashvillehousing
group by SoldAsVacant;


select soldasvacant,
	Case
		when soldasvacant = 'Y' then 'Yes' 
        when SoldAsVacant = 'N' then 'No'
        else soldasvacant
	end as sold_as_vacant
from SQLProject.nashvillehousing;

update SQLProject.nashvillehousing
set SoldAsVacant = Case
		when soldasvacant = 'Y' then 'Yes' 
        when SoldAsVacant = 'N' then 'No'
        else soldasvacant
	end;


-- remove duplicates rows 

WITH RownumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY parcelId,
                         owneraddress,
                         saleprice,
                         saledate,
                         legalreference -- Add all columns that define duplicates
            ORDER BY uniqueid -- Add the order by column for uniqueness
        ) AS row_num
    FROM SQLProject.nashvillehousing
)
delete
FROM RownumCTE
WHERE row_num > 1;










