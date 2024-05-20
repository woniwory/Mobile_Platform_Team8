package com.example.spring_team8.Service;

import com.example.spring_team8.Entity.UserGroup;
import com.example.spring_team8.Repository.UserGroupRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UserGroupService {

    @Autowired
    private UserGroupRepository userGroupRepository;

    public List<UserGroup> getAllUserGroups() {
        return userGroupRepository.findAll();
    }

    public Optional<UserGroup> getUserGroupById(Long id) {
        return userGroupRepository.findById(id);
    }

    public UserGroup createUserGroup(UserGroup userGroup) {
        return userGroupRepository.save(userGroup);
    }

    public UserGroup updateUserGroup(Long id, UserGroup userGroupDetails) {
        Optional<UserGroup> optionalUserGroup = userGroupRepository.findById(id);
        if (optionalUserGroup.isPresent()) {
            UserGroup userGroup = optionalUserGroup.get();
            // Update user and group if necessary
            userGroup.setUser(userGroupDetails.getUser());
            userGroup.setGroup(userGroupDetails.getGroup());
            return userGroupRepository.save(userGroup);
        } else {
            return null; // or throw exception
        }
    }

    public void deleteUserGroup(Long id) {
        userGroupRepository.deleteById(id);
    }



//
//    public int getGroupCountByGroupId(Long groupId) {
//        List<UserGroup> userGroups = userGroupRepository.findByGroup_Id(groupId);
//        return userGroups.size(); // 해당 그룹에 속한 모든 유저그룹 엔티티의 개수를 반환
//    }
//
//    public List<String> getSurveyTitlesByGroupId(Long groupId) {
//        return userGroupRepository.findSurveyTitlesByGroupId(groupId);
//    }
}
