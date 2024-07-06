--Cleaning Data in SQL Queries

Select SaleDate
From PortProj2.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ALTER COLUMN SaleDate DATE

Select *
From PortProj2.dbo.NashvilleHousing

--Populate Property Address data

Select *
From PortProj2.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortProj2.dbo.NashvilleHousing a
JOIN PortProj2.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortProj2.dbo.NashvilleHousing a
JOIN PortProj2.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]


	--Breaking out Address into Individual Columns (Address, City, State)

	Select PropertyAddress
	From PortProj2.dbo.NashvilleHousing

	Select
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
	, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
	From PortProj2.dbo.NashvilleHousing

	ALTER TABLE NashvilleHousing
	Add PropertySplitAddress Nvarchar(255);

	Update NashvilleHousing
	SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

	ALTER TABLE NashvilleHousing
	Add PropertySplitCity Nvarchar(255);

	Update NashvilleHousing
	SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

	Select *
	From PortProj2.dbo.NashvilleHousing


	Select OwnerAddress
	From PortProj2.dbo.NashvilleHousing

	Select
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
	,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
	,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
	From PortProj2.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)





Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortProj2.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
From PortProj2.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END


--Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
				
From PortProj2.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress





--Delete Unused Columns


ALTER TABLE PortProj2.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


Select *
From PortProj2.dbo.NashvilleHousing