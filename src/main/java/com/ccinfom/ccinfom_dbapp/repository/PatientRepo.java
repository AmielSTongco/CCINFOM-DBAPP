package com.ccinfom.ccinfom_dbapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ccinfom.ccinfom_dbapp.model.Patient;

public interface PatientRepo extends JpaRepository<Patient, String>{

}
