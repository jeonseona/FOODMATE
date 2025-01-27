package com.demo.persistence;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.demo.domain.foodRecipe;

public interface AdminRecipeDBRepository extends JpaRepository<foodRecipe, Integer> {
	
	@Query(value = "SELECT * FROM food_recipe WHERE name LIKE %:searchWord% ORDER BY idx DESC", nativeQuery = true)
	List<foodRecipe> getRecipeDBListByName(String searchWord);
	
	@Query(value = "SELECT * FROM food_recipe WHERE idx LIKE :searchWord ORDER BY idx DESC", nativeQuery = true)
	List<foodRecipe> getRecipeDBListByIndex(String searchWord);
	
	@Query(value = "SELECT * FROM food_recipe WHERE idx = :searchWord", nativeQuery = true)
	foodRecipe getRecipeDBByIndex(int searchWord);
}
