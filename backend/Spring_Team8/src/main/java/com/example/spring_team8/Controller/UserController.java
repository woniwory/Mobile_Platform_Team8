package com.example.spring_team8.Controller;

import com.example.spring_team8.Entity.User;
import com.example.spring_team8.dto.UserDTO;
import com.example.spring_team8.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@CrossOrigin("*")
@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public ResponseEntity<User> loginUser(@RequestBody UserDTO userDto) {
        Optional<User> userOptional = userService.authenticateUser(userDto.getUserEmail(), userDto.getUserPassword());
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            return new ResponseEntity<>(user,HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }
    }


    @GetMapping
    public List<UserDTO> getAllUsers() {
        List<User> users = userService.getAllUsers();
        return users.stream()
                .map(User::toDto) // 엔티티 클래스에 정의된 toDto 메서드를 사용하여 DTO로 변환
                .collect(Collectors.toList());
    }

    @GetMapping("/{userId}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable("userId") Long userId) {
        Optional<User> user = userService.getUserById(userId);
        if (user.isPresent()) {
            return new ResponseEntity<>(HttpStatus.OK); // 엔티티 클래스에 정의된 toDto 메서드를 사용하여 DTO로 변환
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping
    public ResponseEntity<User> createUser(@RequestBody UserDTO userDto) {
        User user = UserDTO.toEntity(userDto); // DTO를 엔티티로 변환하는 메서드 사용
        userService.createUser(user);
        return new ResponseEntity<>(user, HttpStatus.CREATED); // 엔티티 클래스에 정의된 toDto 메서드를 사용하여 DTO로 변환
    }


    @PutMapping("/{userId}")
    public ResponseEntity<UserDTO> updateUser(@PathVariable("userId") Long userId, @RequestBody UserDTO userDto) {
        User updatedUser = userService.updateUser(userId, userDto);
        if (updatedUser != null) {
            return new ResponseEntity<>(User.toDto(updatedUser), HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable("id") Long userId) {
        userService.deleteUser(userId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}

