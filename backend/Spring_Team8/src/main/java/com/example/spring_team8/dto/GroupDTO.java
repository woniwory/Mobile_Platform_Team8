package com.example.spring_team8.dto;

import com.example.spring_team8.Entity.Group;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GroupDTO {
    private Long groupId;
    private String groupName;

    public static Group toEntity(GroupDTO groupDTO) {
        Group group = new Group();
        group.setGroupId(groupDTO.getGroupId());
        group.setGroupName(groupDTO.getGroupName());
        return group;
    }
    // 생성자, 게터, 세터, toString 등은 생략했습니다.
}
