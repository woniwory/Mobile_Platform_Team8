package com.example.spring_team8.Entity;

import lombok.Getter;
import lombok.Setter;
import jakarta.persistence.*;

import java.util.Date;


@Getter
@Setter
@Entity
@Table(name = "survey")
public class Survey {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long surveyId;

    private String surveyTitle;

    private String surveyDescription;

    private Date surveyStartDate;

    private Date surveyEndDate;



}
