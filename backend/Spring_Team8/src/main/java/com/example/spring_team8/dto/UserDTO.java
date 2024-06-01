package com.example.spring_team8.dto;

import com.example.spring_team8.Entity.User;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserDTO {
    private Long userId;
    private String userName;
    private String userEmail;
    private String userPassword;
    private String userAccountNumber;



    public static User toEntity(UserDTO userDto) {
        User user = new User();
        user.setUserId(userDto.getUserId());
        user.setUserName(userDto.getUserName());
        user.setUserEmail(userDto.getUserEmail());
        user.setUserPassword(userDto.getUserPassword());
        return user;
    }


}
