package com.repositories;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.domain.Client;
import com.domain.Producer;

public interface ProducerRepository extends JpaRepository<Producer, Long>{

	Producer findByEmail(String email);

	Optional<Producer> findBySupabaseId(UUID supabaseId);
}
