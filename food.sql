
-- 로그인 페이지
ALTER TABLE member_data ADD (no_data NUMBER); 
UPDATE member_data SET no_data = ROWNUM;
ALTER TABLE member_data ADD CONSTRAINT pk_member_data PRIMARY KEY (no_data);

CREATE TABLE MEMBER(
    member_num number,
    ID VARCHAR(30)  PRIMARY KEY,
    NAME VARCHAR(50)  NOT NULL ,
    nickname VARCHAR(50) NOT NULL unique ,
    email VARCHAR(50) NOT NULL ,
    PASSWORD VARCHAR(30) NOT NULL,
    code CHAR(1) DEFAULT 0 ,   -- 0 : 일반회원, 1 : 관리자
    height VARCHAR2(30) ,   -- 키
    weight VARCHAR2(30) ,   -- 몸무게
    gender VARCHAR2(20),        -- input-radio : 성별
    goal VARCHAR2(30),           -- checkbox : 목표
CONSTRAINT fk_id1 FOREIGN KEY(member_num) REFERENCES Member_data(no_data)
);


-- 관리자 페이지
-- 관리자 게시판(음식레시피, Q&A, 1:1문의)
CREATE TABLE admin_board (
    userid VARCHAR2(30),     -- 회원게시판 외래키
    usercode CHAR(1) DEFAULT 1 NOT NULL,
    boardcode CHAR(1) NOT NULL,    -- 코드0 : 레시피, 코드1:Q&A     
    nickname VARCHAR2(20), 
    boardnum NUMBER(30) NOT NULL, -- 기본키
    title VARCHAR2(30) NOT NULL,
    content VARCHAR2(500) NOT NULL,
    image VARCHAR2(500),
    tag VARCHAR2(500),
    regdate DATE DEFAULT SYSDATE,
    count NUMBER(30) DEFAULT 0,  
    PRIMARY KEY (boardnum),
    CONSTRAINT fk_id4 FOREIGN KEY (userid) REFERENCES MEMBER(ID)
);



-- 커뮤니티 페이지
-- 커뮤니티 레시피 데이터 테이블 수정
ALTER TABLE com_recipe ADD (idx NUMBER); -- 인덱스 컬럼 생성
UPDATE com_recipe SET idx = ROWNUM; -- 인덱스컬럼에 값 부여
ALTER TABLE com_recipe ADD CONSTRAINT pk_com_recipe PRIMARY KEY (idx); -- 인덱스 컬럼을 커뮤니티 레시피 데이터의 primary키로 합니다.


--게시글과 댓글 번호 시퀀스
CREATE SEQUENCE boardseq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE replyseq START WITH 1 INCREMENT BY 1;


CREATE TABLE com_board(
    board_num NUMBER primary key, -- com_board_detail 참고1
    recipe_num number ,
    CONSTRAINT fk_id_11 FOREIGN KEY(board_num) REFERENCES com_board_detail(seq),
    CONSTRAINT fk_idx_1 FOREIGN KEY(recipe_num) REFERENCES COM_RECIPE(IDX)   
);


-- 커뮤니티 게시글 클릭시 상세정보
CREATE TABLE com_board_detail(
    seq NUMBER PRIMARY KEY	,
    RECIPE_NUM NUMBER, -- com_recipe 참고1
    d_writer_no   number,  --meber_data 참고1
    d_regdate DATE DEFAULT sysdate,
    cnt NUMBER DEFAULT 0,
    CONSTRAINT fk_seq1 FOREIGN KEY(d_writer_no) REFERENCES MemberData(no_data),  
    CONSTRAINT fk_idx2 FOREIGN KEY(RECIPE_NUM) REFERENCES COM_RECIPE(IDX)
);




-- 커뮤니티 게시글의 댓글
CREATE TABLE reply (
    replynum NUMBER PRIMARY KEY,
    boardnum NUMBER, --com_board_Detail 참고
    CONTENT VARCHAR2(2000) NOT NULL,
    userid NUMBER NOT NULL, -- Member_data 참고
    CONSTRAINT fk_id3 FOREIGN KEY(userid) REFERENCES Memberdata(no_data),
    CONSTRAINT fk_seq_3 FOREIGN KEY(boardnum) REFERENCES com_board_detail(seq)
);



-- 고객센터 페이지 / 기존의 QnA 테이블은 관리자에서 필요로 하기 때문에 삭제하였습니다 !

-- 1:1 문의 테이블 생성
CREATE TABLE inquiries (
    inquiry_id NUMBER(5) PRIMARY KEY,
    NAME VARCHAR(50), 
    email VARCHAR(100), 
    subject VARCHAR(100),
    message VARCHAR(100),
    created_at TIMESTAMP DEFAULT current_timestamp,
    comments VARCHAR(200),
    CONSTRAINT fk_inquiry_id FOREIGN KEY (inquiry_id) REFERENCES Member_data(no_data)
);

create sequence inq_SEQ start with 1 increment by 1;




-- 마이페이지 MyPage 
CREATE TABLE mypage (
    m_seq NUMBER,       -- com_board_detail 참고
    m_id VARCHAR2(30),  -- MemberData 참고
    goal VARCHAR2(300),  
    bmi NUMBER PRIMARY KEY,
    food_preference CHAR(1) DEFAULT 'y',      -- 음식선호도 : 'y'는 선호 | 'n'은 불호
    allergy CHAR(1) DEFAULT 'n',       -- 알레르기 음식 : 'n'은 없음 | 'y'는 있음
    CONSTRAINT fk_seq9 FOREIGN KEY(m_seq) REFERENCES com_board_detail(seq), 
    CONSTRAINT fk_id9 FOREIGN KEY(m_num) REFERENCES Member_data(no_data)
);



-- 여기서부터 추천시스템 페이지 DB입니다. 모두 실행시켜주세요
ALTER TABLE food_recipe ADD CONSTRAINT pk_food_recipe PRIMARY KEY (idx);

---  추천시스템 목록 페이지
create table recommend_list(
    food_number number primary key,
    food_title varchar2(128),
    food_img varchar2(4000),
    CONSTRAINT fk_foodnum FOREIGN KEY(food_number) REFERENCES food_recipe(idx)
);


--  추천시스템 상세페이지
create table recommend_detail(
    food_seq	NUMBER,
    NAME	VARCHAR2(128),
    IMAGES	VARCHAR2(4000),
    RECIPECATEGORY	VARCHAR2(26),
    KEYWORDS	VARCHAR2(256),
    RECIPEINGREDIENTPARTS	VARCHAR2(1024),
    CALORIES	NUMBER(38,1),
    FATCONTENT	NUMBER(38,1),
    SATURATEDFATCONTENT	NUMBER(38,1),
    CHOLESTEROLCONTENT	NUMBER(38,1),
    SODIUMCONTENT	NUMBER(38,1),
    CARBOHYDRATECONTENT	NUMBER(38,1),
    FIBERCONTENT	NUMBER(38,1),
    SUGARCONTENT	NUMBER(38,1),
    PROTEINCONTENT	NUMBER(38,1),
    RECIPEINSTRUCTIONS	VARCHAR2(4000),
    CONSTRAINT fk_foodseq FOREIGN KEY(food_seq) REFERENCES food_recipe(idx)
);

-- -- 이 테이블들은 추가사항이긴한데 아직 실행시키지 말아주세요 !! 
-- CREATE TABLE qna_detail (
--     id INT PRIMARY KEY,
--     admin_board_id INT NOT NULL,
--     questionDetail VARCHAR(255),
--     answerDetail VARCHAR(255),
--     FOREIGN KEY (admin_board_id) REFERENCES admin_board (boardnum)
-- );

-- -- 1:1 문의 게시글 목록 테이블 생성
-- CREATE TABLE inquiry_list (
--     inquiry_id NUMBER(5) PRIMARY KEY,
--     name VARCHAR(50), 
--     email VARCHAR(100), 
--     subject VARCHAR(100),
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     status VARCHAR(20)
-- );

-- -- inquiry_id 시퀀스 생성
-- CREATE SEQUENCE inquiry_list_SEQ START WITH 1 INCREMENT BY 1;  --













