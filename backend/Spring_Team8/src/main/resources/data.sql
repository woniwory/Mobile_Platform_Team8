-- src/main/resources/data.sql

INSERT INTO user (user_account_number, user_email, user_name, user_password) VALUES ('123123123', 'woniwory@naver.com','정성원','정성원Password');
INSERT INTO user (user_account_number, user_email, user_name, user_password) VALUES ('234234234', 'mwiliams@naver.com','이호영','이호영Password');

INSERT INTO `group` (group_name) VALUES ('그룹1');
INSERT INTO `group` (group_name) VALUES ('그룹2');
INSERT INTO `group` (group_name) VALUES ('그룹3');

INSERT INTO survey (survey_title, survey_description, survey_start_date, survey_end_date, group_id, participants) VALUES ('survey title1','survey1 description','2024-05-18', '2024-05-20','1',15);
INSERT INTO survey (survey_title, survey_description, survey_start_date, survey_end_date, group_id, participants) VALUES ('survey title2','survey2 description','2024-05-20', '2024-05-21','1',20);
INSERT INTO survey (survey_title, survey_description, survey_start_date, survey_end_date, group_id, participants) VALUES ('survey title3','survey3 description','2024-05-22', '2024-05-23','1',25);
INSERT INTO survey (survey_title, survey_description, survey_start_date, survey_end_date, group_id, participants) VALUES ('survey title4','survey4 description','2024-05-24', '2024-05-25','1',30);
INSERT INTO survey (survey_title, survey_description, survey_start_date, survey_end_date, group_id, participants) VALUES ('survey title5','survey5 description','2024-05-26', '2024-05-27','1',35);
INSERT INTO survey (survey_title, survey_description, survey_start_date, survey_end_date, group_id, participants) VALUES ('survey title6','survey6 description','2024-05-28', '2024-05-29','1',40);
INSERT INTO survey (survey_title, survey_description, survey_start_date, survey_end_date, group_id, participants) VALUES ('survey title7','survey7 description','2024-05-30', '2024-05-31','1',45);


INSERT INTO user_survey (user_id, survey_id,is_admin) VALUES (1,2,true);
INSERT INTO user_survey (user_id, survey_id,is_admin) VALUES (1,3,true);



INSERT INTO question (survey_id, question_text,required) VALUES (1,'어떤 프로그래밍 언어를 사용하나요?',true);
INSERT INTO question (survey_id, question_text,required) VALUES (1,'왜 사용하나요?',true);
INSERT INTO question (survey_id, question_text,required) VALUES (2,'밥 몇시에 먹었나요?',true);
INSERT INTO question (survey_id, question_text,required) VALUES (2,'뭘 먹었나요?',true);


INSERT INTO choice (question_id, choice_text) VALUES (1,'파이썬');
INSERT INTO choice (question_id, choice_text) VALUES (1,'자바');
INSERT INTO choice (question_id, choice_text) VALUES (1,'C++');
INSERT INTO choice (question_id, choice_text) VALUES (4,'돈까스');
INSERT INTO choice (question_id, choice_text) VALUES (4,'제육볶음');
INSERT INTO choice (question_id, choice_text) VALUES (4,'국밥');

INSERT INTO response (question_id, user_id, choice_id) VALUES (1,1,1);
INSERT INTO response (question_id, user_id, choice_id) VALUES (1,2,3);
INSERT INTO response (question_id, user_id, response_text) VALUES (2,1,'그냥');
INSERT INTO response (question_id, user_id, response_text) VALUES (2,2,'재밌어서');


INSERT INTO response (question_id, user_id, response_text) VALUES (3,1,'12');
INSERT INTO response (question_id, user_id, response_text) VALUES (3,2,'1');
INSERT INTO response (question_id, user_id, choice_id) VALUES (4,1,1);
INSERT INTO response (question_id, user_id, choice_id) VALUES (4,2,3);

