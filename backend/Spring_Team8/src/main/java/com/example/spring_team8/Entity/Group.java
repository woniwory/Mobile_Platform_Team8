package com.example.spring_team8.Entity;

import com.example.spring_team8.dto.GroupDTO;
import lombok.Getter;
import lombok.Setter;

import jakarta.persistence.*;

@Entity
@Table(name = "`group`") // 'group' is a reserved keyword, so it needs to be escaped
@Getter
@Setter
public class Group {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "group_id") // Define the column name for the primary key
    private Long groupId; // Change 'groupId' to 'id' to match the column name

    private String groupName;

    // Constructors, getters, setters, toString, etc.


    public GroupDTO toDto() {
        GroupDTO groupDTO = new GroupDTO();
        groupDTO.setGroupId(this.groupId);
        groupDTO.setGroupName(this.groupName);
        return groupDTO;
    }

}
