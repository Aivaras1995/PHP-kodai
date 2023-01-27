<?php

namespace Appsas\Repositories;

class AddressRepository extends BaseRepository implements RepositoryInterface
{

    public function create(array $data): void
    {
        $this->db->query(
            "INSERT INTO `addresses`(`country_iso`, `city`, `street`, `postcode`)
                    VALUES (:country_iso, :city, :street, :email, :postcode)",
            $data);
    }

    public function findById(int $id): array
    {
        return $this->db->query('SELECT p.* FROM addresses a WHERE a.id = :id', ['id' => $id])[0];
    }

    public function update(array $data): void
    {   $this->db->query(
            "UPDATE `addresses` 
                    SET `country_iso` = :country_iso, 
                        `city` = :city, 
                        `street` = :street,                                 
                        `postcode` = :postcode 
                    WHERE `id` = :id",
            $data
        );
    }

    public function delete(int $id): void
    {
        $this->db->query(
            "DELETE FROM `address` WHERE `id` = :id",
            ['id' => $id]
        );
    }
}