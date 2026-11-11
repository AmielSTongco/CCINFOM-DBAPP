package com.ccinfom.ccinfom_dbapp.service;

import com.ccinfom.ccinfom_dbapp.model.Patient;
import com.ccinfom.ccinfom_dbapp.repository.PatientRepo;
import org.springframework.stereotype.Service;

@Service 
public class PatientService {

    private final PatientRepo patientRepo;

    public PatientService(PatientRepo patientRepo) {
        this.patientRepo = patientRepo;
    }

    public Patient saveDetails(Patient patient) {
        return patientRepo.save(patient);
    }
}