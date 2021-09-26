#!/bin/bash

# cd /Volumes/Sites/_FILE_DUMPS/BX_PDFS
# for file in `find . -name "*.pdf"`; do \
#   NAME=$(echo $file | cut -c3-)
# 	echo "UNCOMPRESSING $NAME"
# 	pdftk $NAME output ../UNCOMPRESSED/$NAME uncompress
# done;

rm -rf /Volumes/Sites/_FILE_DUMPS/INCREMENTS
cp -r /Volumes/Sites/_FILE_DUMPS/UNCOMPRESSED /Volumes/Sites/_FILE_DUMPS/INCREMENTS
cd /Volumes/Sites/_FILE_DUMPS/INCREMENTS
for file in `find . -name "*.pdf"`; do \
  NAME=$(echo $file | cut -c3-)
  echo "SED $NAME"

  LC_CTYPE=C sed -i "" "s/T (EffectiveDateDay)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (EffectiveDateMonth)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (EffectiveDateYear)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (EffectiveDate)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (IssueDateDay)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (IssueDateMonth)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (IssueDateYear)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (IssueDate)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (ExpirationDateDay)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (ExpirationDateMonth)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (ExpirationDateYear)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (ExpirationDate)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (SuretyCompany)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (SuretyPhone)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (SuretyEmail)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (SuretyFullAddress)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (SuretyAddress)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (SuretyCity)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (SuretyState)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (SuretyPostalCode)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (TBEName)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (TBEPhone)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (TBEEmail)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (TBEFullAddress)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (TBEAddress)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (TBECityState)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (TBECity)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (TBEState)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (TBEPostalCode)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (TBEPhone)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (BusinessFullAddress)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (BusinessAddress)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (BusinessCity)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (BusinessState)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (BusinessCounty)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (BusinessPostalCode)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (GenericObligee)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (GenericObligeeAddress)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (GenericObligeeCity)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (GenericObligeeState)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (GenericObligeePostalCode)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (JobLocationName)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (JobLocationAddress)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (JobLocationCity)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (JobLocationState)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (JobLocationPostalCode)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (Email)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (Address)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (City)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (State)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (County)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (PostalCode)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (Telephone)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (LimitAlpha)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (Limit)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (UserSignature)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (UsersFullName)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (CorporateSeal)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (principal_1_Title)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (principal_1_FullName)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (principal_2_Title)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (principal_2_FullName)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (BusinessName)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (BondNumber)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (DBA)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (CaseNumber)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (EstateName)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (SuretyIncState)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (Instrm_Letters)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (CounterSignatureAZ)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (CounterNameAZ)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (CounterLicenseAZ)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (WitnessSignature1)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (WitnessSignature2)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (WitnessSignature3)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (LostTitleVIN)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (LostTitleYear)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (LostTitleMake)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (LostTitleModel)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (LostTitleColor)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (LostTitleBodyStyle)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (LostTitlePlate)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (NotarySignature)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (NotarySeal)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (CommissionDate)/T (FORMFIELD_$RANDOM)/" $NAME

  LC_CTYPE=C sed -i "" "s/T (PremiumRateDollarFormat)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (TypeOfEntity)/T (FORMFIELD_$RANDOM)/" $NAME
  LC_CTYPE=C sed -i "" "s/T (DBAPrincipal)/T (FORMFIELD_$RANDOM)/" $NAME
done;

cd /Volumes/Sites/_FILE_DUMPS/INCREMENTS
for file in `find . -name "*.pdf"`; do \
  NAME=$(echo $file | cut -c3-)
	echo "COMPRESSING $NAME"
	pdftk $NAME output ../COMPRESSED/$NAME uncompress
done;
