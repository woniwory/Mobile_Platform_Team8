package com.example.spring_team8.Entity;

import com.example.spring_team8.dto.QuestionDTO;
import com.example.spring_team8.dto.SurveyDTO;
import lombok.Getter;
import lombok.Setter;

import jakarta.persistence.*;

@Entity
@Table(name = "question")
@Getter
@Setter
public class Question {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long questionId;

    @ManyToOne
    @JoinColumn(name = "survey_id")
    private Survey survey;

    private boolean required;

    private String questionText;



}
