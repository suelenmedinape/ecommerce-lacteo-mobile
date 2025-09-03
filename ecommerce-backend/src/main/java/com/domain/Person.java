package com.domain;

import com.enums.Role;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.MappedSuperclass;
import jakarta.persistence.OneToOne;
import jakarta.validation.constraints.NotNull;

@MappedSuperclass
public class Person{

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@NotNull
	@Column(nullable = false)
	private String name;
	
	@NotNull
	@Column(nullable = false, unique = true)
	private String email;
	private String phone;
	
	@OneToOne(cascade = CascadeType.ALL)
	private Address address;
	
	@Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;
	
	@Column(nullable = false, unique = true)
    private String supabaseId;

	
	public Person() {
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public Address getAddress() {
		return address;
	}

	public void setAddress(Address address) {
		this.address = address;
	}

	public Role getRole() {
		return role;
	}

	public void setRole(Role role) {
		this.role = role;
	}

	public String getSupabaseId() {
		return supabaseId;
	}

	public void setSupabaseId(String supabaseId) {
		this.supabaseId = supabaseId;
	}
}
