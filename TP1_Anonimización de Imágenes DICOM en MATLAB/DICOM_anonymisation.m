
a = 1;
files = dir('DICOM\*Img*');
for p = 1:numel(files)
    DICOMinfo = dicominfo(strcat('DICOM\',files(p).name));
    DICOMinfo.PatientName = 'Anonimo';
    age = DICOMinfo.PatientBirthDate;
    newAge = "";
    for c= 1:6
        newAge = plus(newAge,num2str(age(c)));
    end
    DICOMinfo.StudyID = '0000000';
    DICOMinfo.InstitutionName = '0000000';
    DICOMinfo.AdditionalPatient = '0000000';
    DICOMinfo.OtherPatientID = '0000000';
    DICOMinfo.PatientID = '0000000';
    DICOMinfo.OperatorName = '0000000';
    DICOMinfo.PhysicianReadingStudy = '0000000';
    DICOMinfo.PerformingPhysicianName = '0000000';
    DICOMinfo.ReferringPhysicianName = '0000000';
    
    path2 = "D:\Escritorio\Universidad\Universidad\7to Semestre\IA en imagenes medicas\TP 1 IAIM CUCEI 2022B JMDZ\DICOM2\";
    data = dicomread(strcat('DICOM\',files(p).name));
    dicomwrite(data, strcat(path2, strcat('Imagen_Anonym_',num2str(a,'%d'))), DICOMinfo, 'CreateMode','copy');
    a = a+1;
end