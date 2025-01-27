package com.demo.persistence;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.demo.domain.Recommend_History;

public interface Recommend_HistoryRepository extends JpaRepository<Recommend_History, String> {

	// 회원별 추천받은 음식(레시피)기록 조회
	@Query("SELECT rh FROM RecommendHistory rh JOIN rh.member m WHERE m.id =:id")
	public List<Recommend_History> getMyRecommendHistoryById(@Param("id") String id);
	
}
