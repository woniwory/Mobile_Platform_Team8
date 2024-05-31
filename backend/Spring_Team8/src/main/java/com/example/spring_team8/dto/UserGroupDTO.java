package com.example.spring_team8.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserGroupDTO {
    private Long id;
    private UserDTO user;
    private GroupDTO group;
    private SurveyDTO survey;

    // 생성자, 게터, 세터, toString 등은 생략했습니다.
}
