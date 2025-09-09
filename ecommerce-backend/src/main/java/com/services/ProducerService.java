package com.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import java.util.Map;

import com.domain.Producer;
import com.repositories.ProducerRepository;

@Service
public class ProducerService {

	@Autowired
	private ProducerRepository producerRepository;
	
	public Producer findByEmail(String email) {
		return producerRepository.findByEmail(email);
	}
	
	
	@Autowired
    private RestTemplate restTemplate;

    @Value("${supabase.url}")
    private String supabaseUrl;

    @Value("${supabase.service-role-key}")
    private String serviceRoleKey;
    

    /*
     * metodo auxiliar usado para atualizar o meta dado de um admin
     */
    
    public void setAdminRoleInSupabaseAuth(String supabaseId) {
        String url = supabaseUrl + "/auth/v1/admin/users/" + supabaseId;

        HttpHeaders headers = new HttpHeaders();
        headers.set("apikey", serviceRoleKey);
        headers.set("Authorization", "Bearer " + serviceRoleKey);
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, Object> metadata = Map.of("role", "ROLE_ADMIN");
        Map<String, Object> body = Map.of("user_metadata", metadata);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);

        try {
            restTemplate.exchange(url, HttpMethod.PUT, entity, String.class);
            System.out.println("SUCESSO: Metadados de admin definidos para o usuário: " + supabaseId);
        } catch (HttpClientErrorException e) {
            System.err.println("ERRO ao atualizar metadados no Supabase: " + e.getStatusCode() + " " + e.getResponseBodyAsString());
            throw new RuntimeException("Falha ao atualizar permissões do usuário.", e);
        }
    }
}
