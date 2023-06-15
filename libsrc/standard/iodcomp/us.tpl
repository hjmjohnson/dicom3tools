CompositeIOD="EnhancedUltrasoundVolume"			Condition="EnhancedUltrasoundVolumeInstance"
	InformationEntity="File"
		Module="FileMetaInformation"							Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"										Usage="M"
		Module="ClinicalTrialSubject"							Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"									Usage="M"
		Module="PatientStudy"									Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"								Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"									Usage="M"
		Module="ClinicalTrialSeries"							Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="EnhancedUSSeries"								Usage="M"
	InformationEntityEnd
	InformationEntity="FrameOfReference"
		Module="FrameOfReference"								Usage="M"
		Module="UltrasoundFrameOfReference"						Usage="M"
		Module="Synchronization"								Usage="M"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"								Usage="M"
		Module="EnhancedGeneralEquipment"						Usage="M"
	InformationEntityEnd
	InformationEntity="Acquisition"
		Module="GeneralAcquisition"								Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="GeneralImage"									Usage="M"
		Module="GeneralReference"								Usage="U"	Condition="NeedModuleGeneralReference"
		Module="ImagePixel"										Usage="M"
		Module="EnhancedContrastBolus"							Usage="C"	Condition="NeedModuleEnhancedContrastBolus"
		Module="MultiFrameFunctionalGroupsCommon"				Usage="M"
		Module="MultiFrameFunctionalGroupsForEnhancedUSVolume"	Usage="M"
		Module="MultiFrameDimension"							Usage="M"
		Module="CardiacSynchronization"							Usage="C"	Condition="NeedModuleCardiacSynchronization"
		Module="RespiratorySynchronization"						Usage="C"	Condition="NeedModuleRespiratorySynchronization"
		Module="Device"											Usage="U"	Condition="NeedModuleDevice"
		Module="AcquisitionContext"								Usage="M"
		Module="Specimen"										Usage="U"	Condition="NeedModuleSpecimen"
		Module="EnhancedPaletteColorLookupTable"				Usage="U"	Condition="NeedModuleEnhancedPaletteColorLookupTable"
		Module="EnhancedUSImage"								Usage="M"
		Module="IVUSImage"										Usage="C"	Condition="ModalityIsIVUS"
		Module="ExcludedIntervals"								Usage="U"	Condition="NeedModuleExcludedIntervals"
		Module="ICCProfile"										Usage="U"	Condition="NeedModuleICCProfile"
		Module="SOPCommon"										Usage="M"
		Module="CommonInstanceReference"						Usage="U"	Condition="NeedModuleCommonInstanceReference"
		Module="FrameExtraction"								Usage="C"	Condition="NeedModuleFrameExtraction"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="EnhancedUltrasoundVolumeQTUS"			Condition="EnhancedUltrasoundVolumeInstance"	Profile="QTUS"
	InformationEntity="File"
		Module="FileMetaInformation"							Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"										Usage="M"
		Module="ClinicalTrialSubject"							Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"									Usage="M"
		Module="PatientStudy"									Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"								Usage="U"	Condition="NeedModuleClinicalTrialStudy"
		Module="QTUSEnhancedUltrasoundVolumeProfileStudy"		Usage="M"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"									Usage="M"
		Module="ClinicalTrialSeries"							Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="EnhancedUSSeries"								Usage="M"
		Module="QTUSEnhancedUltrasoundVolumeProfileSeries"		Usage="M"
	InformationEntityEnd
	InformationEntity="FrameOfReference"
		Module="FrameOfReference"								Usage="M"
		Module="UltrasoundFrameOfReference"						Usage="M"
		Module="Synchronization"								Usage="M"
		Module="QTUSEnhancedUltrasoundVolumeProfileFrameOfReference"	Usage="M"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"								Usage="M"
		Module="EnhancedGeneralEquipment"						Usage="M"
		Module="QTUSEnhancedUltrasoundVolumeProfileEquipment"	Usage="M"
	InformationEntityEnd
	InformationEntity="Acquisition"
		Module="GeneralAcquisition"								Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="GeneralImage"									Usage="M"
		Module="GeneralReference"								Usage="U"	Condition="NeedModuleGeneralReference"
		Module="ImagePixel"										Usage="M"
		Module="EnhancedContrastBolus"							Usage="C"	Condition="NeedModuleEnhancedContrastBolus"
		Module="MultiFrameFunctionalGroupsCommon"				Usage="M"
		Module="MultiFrameFunctionalGroupsForEnhancedUSVolume"	Usage="M"
		Module="MultiFrameDimension"							Usage="M"
		Module="CardiacSynchronization"							Usage="C"	Condition="NeedModuleCardiacSynchronization"
		Module="RespiratorySynchronization"						Usage="C"	Condition="NeedModuleRespiratorySynchronization"
		Module="Device"											Usage="U"	Condition="NeedModuleDevice"
		Module="AcquisitionContext"								Usage="M"
		Module="Specimen"										Usage="U"	Condition="NeedModuleSpecimen"
		Module="EnhancedPaletteColorLookupTable"				Usage="U"	Condition="NeedModuleEnhancedPaletteColorLookupTable"
		Module="EnhancedUSImage"								Usage="M"
		Module="IVUSImage"										Usage="C"	Condition="ModalityIsIVUS"
		Module="ExcludedIntervals"								Usage="U"	Condition="NeedModuleExcludedIntervals"
		Module="ICCProfile"										Usage="U"	Condition="NeedModuleICCProfile"
		Module="SOPCommon"										Usage="M"
		Module="CommonInstanceReference"						Usage="U"	Condition="NeedModuleCommonInstanceReference"
		Module="FrameExtraction"								Usage="C"	Condition="NeedModuleFrameExtraction"
		Module="QTUSEnhancedUltrasoundVolumeProfileInstance"	Usage="M"
	InformationEntityEnd
CompositeIODEnd

