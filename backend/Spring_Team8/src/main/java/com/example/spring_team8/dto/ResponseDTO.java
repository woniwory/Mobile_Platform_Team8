package com.example.spring_team8.dto;

import com.example.spring_team8.Entity.User;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResponseDTO {
    private Long responseId;
    private Long questionId;
    private Long userId;
    private String responseText;
    private Long choiceId;

    // 생성자, 게터, 세터, toString 등은 생략했습니다.
}
