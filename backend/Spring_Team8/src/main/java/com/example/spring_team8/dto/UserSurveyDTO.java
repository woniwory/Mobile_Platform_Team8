package com.example.spring_team8.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserSurveyDTO {
    private Long userSurveyId;
    private UserDTO user;
    private SurveyDTO survey;
    private boolean isAdmin;
    private boolean feeStatus;

    // 생성자, 게터, 세터, toString 등은 생략했습니다.
}
