--CLEANING DATA IN SQL QUERIES

select *
from NasvilleHousing



--Standardise Date Format

select saledate, convert (date,saledate)
from NasvilleHousing


alter table nasvillehousing
add Saledateconverted as date

update NasvilleHousing
set saledate = convert(date,saledate)



--Populate Property Address Data

select PropertyAddress
from NasvilleHousing

select PropertyAddress
from NasvilleHousing
where PropertyAddress is null

select *
from NasvilleHousing
where PropertyAddress is null

select a.parcelid, a.PropertyAddress,b.parcelid, b.PropertyAddress
from NasvilleHousing a
join NasvilleHousing b
on a.parcelid = b.parcelid
and a.[UniqueID ]<> b.[UniqueID ]


select a.parcelid, a.PropertyAddress,b.parcelid, b.PropertyAddress, isnull(a.propertyaddress,b.propertyaddress)
from NasvilleHousing a
join NasvilleHousing b
on a.parcelid = b.parcelid
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from NasvilleHousing a
join NasvilleHousing b
on a.parcelid = b.parcelid
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

select *
from NasvilleHousing
where PropertyAddress is null



--Breaking Out Address Into Individual Coloumns (Address,City,State)

Select propertyaddress
from NasvilleHousing

select 
SUBSTRING(propertyaddress,1,CHARINDEX(',' , propertyaddress)-1) as PropertysplitAddress 
,SUBSTRING(propertyaddress,CHARINDEX(',' , propertyaddress)+1, len (propertyaddress)) as PropertyslitCity
from NasvilleHousing


alter table nasvillehousing
add PropertysplitAddress nvarchar(255)

update NasvilleHousing
set PropertysplitAddress = SUBSTRING(propertyaddress,1,CHARINDEX(',' , propertyaddress)-1) 


alter table nasvillehousing
add PropertyslitCity nvarchar(255)

update NasvilleHousing
set PropertyslitCity = SUBSTRING(propertyaddress,CHARINDEX(',' , propertyaddress)+1, len (propertyaddress))


select *
from NasvilleHousing

select owneraddress
from NasvilleHousing

select
SUBSTRING(owneraddress, 1,CHARINDEX(',' , owneraddress)-1)
,SUBSTRING(owneraddress,CHARINDEX(',' , owneraddress)+1, LEN(owneraddress))
from NasvilleHousing

--alternate option

select
PARSENAME(Replace(owneraddress,',' , '.'),3) 
,PARSENAME(Replace(owneraddress,',' , '.'),2)
,PARSENAME(Replace(owneraddress,', ', '.'),1)
from NasvilleHousing


alter table nasvillehousing
add Ownersplitaddress nvarchar(255)

update NasvilleHousing
set Ownersplitaddress = PARSENAME(Replace(owneraddress,',' , '.'),3) 


alter table nasvillehousing
add Ownersplitcity nvarchar(255)

update NasvilleHousing
set Ownersplitcity = PARSENAME(Replace(owneraddress,',' , '.'),2)


alter table nasvillehousing
add Ownersplitstate nvarchar(255)

update NasvilleHousing
set Ownersplitstate = PARSENAME(Replace(owneraddress,', ', '.'),1)

select
from NasvilleHousing



--Change Y and N To Yes and No In "SoldAsVacant" Field

Select distinct(soldasvacant),count(SoldAsVacant)
from NasvilleHousing
group by SoldAsVacant
order by 2

select Soldasvacant
,case when soldasvacant = 'Y' then 'Yes'
 when soldasvacant = 'N' then 'No'
else soldasvacant
end
from NasvilleHousing

update NasvilleHousing
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
 when soldasvacant = 'N' then 'No'
else soldasvacant
end
from NasvilleHousing




--Remove Duplicates

with RowNumCTE as (
select*,
row_number () over ( partition by parcelid,propertyaddress,saledate,saleprice,legalreference
order by uniqueid
)  row_num
from NasvilleHousing
--order by parcelid
)
--select* 
Delete
from RowNumCTE
where row_num >1
--order by propertyaddress


select parcelid,propertyaddress,saledate,saleprice,legalreference,count(*)
from NasvilleHousing
group by parcelid,propertyaddress,saledate,saleprice,legalreference 
having count (*)>1 



--Deleting Unsed Columns

Alter table nasvillehousing
drop column  Owneraddress,Propertyaddress,Taxdistrict

Alter table nasvillehousing
drop column  Saledate

select*
from NasvilleHousing


