package com.ccinfom.ccinfom_dbapp.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.ccinfom.ccinfom_dbapp.model.Patient;
import com.ccinfom.ccinfom_dbapp.service.PatientService;

@RestController 
public class PatientController {

    private final PatientService patientService;

    public PatientController(PatientService patientService) {
        this.patientService = patientService;
    }

    @PostMapping("/addPatient")
    public Patient addPatient(@RequestBody Patient patient) {
        return patientService.saveDetails(patient);
    }
}