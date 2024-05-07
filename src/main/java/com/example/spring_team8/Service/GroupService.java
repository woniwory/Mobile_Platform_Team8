package com.example.spring_team8.Service;

import com.example.spring_team8.Entity.Group;
import com.example.spring_team8.Repository.GroupRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class GroupService {

    @Autowired
    private GroupRepository groupRepository;

    public List<Group> getAllGroups() {
        return groupRepository.findAll();
    }

    public Optional<Group> getGroupById(Long id) {
        return groupRepository.findById(id);
    }

    public Group createGroup(Group group) {
        return groupRepository.save(group);
    }

    public Group updateGroup(Long id, Group groupDetails) {
        Optional<Group> optionalGroup = groupRepository.findById(id);
        if (optionalGroup.isPresent()) {
            Group group = optionalGroup.get();
            group.setGroupName(groupDetails.getGroupName()); // 이름 변경
            return groupRepository.save(group);
        } else {
            return null; // or throw exception
        }
    }

    public void deleteGroup(Long id) {
        groupRepository.deleteById(id);
    }
}
