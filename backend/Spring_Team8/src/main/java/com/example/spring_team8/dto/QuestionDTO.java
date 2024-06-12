package com.example.spring_team8.dto;

import com.example.spring_team8.Entity.Question;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class QuestionDTO {
    private Long questionId;
    private Long surveyId;
    private boolean required;
    private String questionText;
    private Boolean type;

}
