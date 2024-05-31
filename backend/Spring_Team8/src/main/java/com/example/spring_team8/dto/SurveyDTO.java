package com.example.spring_team8.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class SurveyDTO {

    private Long surveyId;
    private String surveyTitle;
    private String surveyDescription;
    private Date surveyStartDate;
    private Date surveyEndDate;
    private Long participants;


    // 생성자, 게터, 세터, toString 등은 생략했습니다.
}
