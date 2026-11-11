package com.ccinfom.ccinfom_dbapp.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDate;

@Entity
@Table(name = "patients")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Patient {

    @Id
    @Column(name = "pat_no", length = 20, nullable = false)
    private String patNo;

    @Column(name = "lastname", length = 80)
    private String lastname;

    @Column(name = "fname", length = 100)
    private String fname;

    @Column(name = "mname", length = 80)
    private String mname;

    @Column(name = "birthdt")
    private LocalDate birthdt;

    @Column(name = "sex", length = 10)
    private String sex;

    @Column(name = "location_id")
    private Integer locationId;

    @Column(name = "phone", length = 30)
    private String phone;

    @Column(name = "regdate")
    private LocalDate regdate;
}