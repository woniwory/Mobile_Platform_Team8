package com.example.spring_team8.Entity;

import com.example.spring_team8.Entity.Survey;
import com.example.spring_team8.Entity.User;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "user_survey")

public class UserSurvey {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userSurveyId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "survey_id")
    private Survey survey;


    private boolean isAdmin;



}
