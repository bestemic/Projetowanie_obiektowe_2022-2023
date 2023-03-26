<?php

namespace App\Controller;

use App\Entity\Category;
use Doctrine\Persistence\ManagerRegistry;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

#[Route('/api', name: 'api_')]
class CategoryRestController extends AbstractController
{

    #[Route('/category', name: 'category_index', methods: ['GET'])]
    public function index(ManagerRegistry $doctrine): Response
    {
        $categories = $doctrine
            ->getRepository(Category::class)
            ->findAll();

        $data = [];

        foreach ($categories as $category) {
            $data[] = [
                'id' => $category->getId(),
                'name' => $category->getName(),
                'description' => $category->getDescription(),
            ];
        }

        return $this->json($data);
    }

    #[Route('/category', name: 'category_new', methods: ['POST'])]
    public function new(ManagerRegistry $doctrine, Request $request): Response
    {

        $entityManager = $doctrine->getManager();
        $parameters = json_decode($request->getContent(), true);

        $category = new Category();
        $category->setName($parameters['name']);
        $category->setDescription($parameters['description']);

        $entityManager->persist($category);
        $entityManager->flush();

        return $this->json($category);
    }

    #[Route('/category/{id}', name: 'category_show', methods: ['GET'])]
    public function show(ManagerRegistry $doctrine, int $id): Response
    {
        $category = $doctrine->getRepository(Category::class)->find($id);

        if (!$category) {
            return $this->json('No category found for id' . $id, 404);
        }

        $data = [
            'id' => $category->getId(),
            'name' => $category->getName(),
            'description' => $category->getDescription(),
        ];

        return $this->json($data);
    }

    #[Route('/category/{id}', name: 'category_edit', methods: ['PUT'])]
    public function edit(ManagerRegistry $doctrine, Request $request, int $id): Response
    {
        $entityManager = $doctrine->getManager();
        $category = $entityManager->getRepository(Category::class)->find($id);

        if (!$category) {
            return $this->json('No category found for id' . $id, 404);
        }

        $parameters = json_decode($request->getContent(), true);

        $category->setName($parameters['name']);
        $category->setDescription($parameters['description']);
        $entityManager->flush();

        $data = [
            'id' => $category->getId(),
            'name' => $category->getName(),
            'description' => $category->getDescription(),
        ];

        return $this->json($data);
    }

    #[Route('/category/{id}', name: 'category_delete', methods: ['DELETE'])]
    public function delete(ManagerRegistry $doctrine, int $id): Response
    {
        $entityManager = $doctrine->getManager();
        $category = $entityManager->getRepository(Category::class)->find($id);

        if (!$category) {
            return $this->json('No category found for id' . $id, 404);
        }

        $entityManager->remove($category);
        $entityManager->flush();

        return $this->json('Deleted a category successfully with id ' . $id);
    }
}
