package com.demo.persistence;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.demo.domain.askBoard;

@Repository 
public interface CustomerServiceRepository extends JpaRepository<askBoard, Long> {

	

    // Named 쿼리 사용 예시
    @Query(value="SELECT * FROM ask_board WHERE subject = :subject", nativeQuery = true)
    List<askBoard> findBySubjectNamedQuery(@Param("subject") String subject);
	
    @Query(value="SELECT * FROM ask_board ORDER BY created_at", nativeQuery = true)
    List<askBoard> getInquiryList();
}