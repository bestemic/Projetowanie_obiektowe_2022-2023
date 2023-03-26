<?php

namespace App\Controller;

use App\Entity\Product;
use Doctrine\Persistence\ManagerRegistry;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

#[Route('/api', name: 'api_')]
class ProductRestController extends AbstractController
{

    #[Route('/product', name: 'product_index', methods: ['GET'])]
    public function index(ManagerRegistry $doctrine): Response
    {
        $products = $doctrine
            ->getRepository(Product::class)
            ->findAll();

        $data = [];

        foreach ($products as $product) {
            $data[] = [
                'id' => $product->getId(),
                'name' => $product->getName(),
                'price' => $product->getPrice(),
            ];
        }

        return $this->json($data);
    }

    #[Route('/product', name: 'product_new', methods: ['POST'])]
    public function new(ManagerRegistry $doctrine, Request $request): Response
    {

        $entityManager = $doctrine->getManager();
        $parameters = json_decode($request->getContent(), true);

        $product = new Product();
        $product->setName($parameters['name']);
        $product->setPrice($parameters['price']);

        $entityManager->persist($product);
        $entityManager->flush();

        return $this->json($product);
    }

    #[Route('/product/{id}', name: 'product_show', methods: ['GET'])]
    public function show(ManagerRegistry $doctrine, int $id): Response
    {
        $product = $doctrine->getRepository(Product::class)->find($id);

        if (!$product) {
            return $this->json('No product found for id' . $id, 404);
        }

        $data = [
            'id' => $product->getId(),
            'name' => $product->getName(),
            'price' => $product->getPrice(),
        ];

        return $this->json($data);
    }

    #[Route('/product/{id}', name: 'product_edit', methods: ['PUT'])]
    public function edit(ManagerRegistry $doctrine, Request $request, int $id): Response
    {
        $entityManager = $doctrine->getManager();
        $product = $entityManager->getRepository(Product::class)->find($id);

        if (!$product) {
            return $this->json('No product found for id' . $id, 404);
        }

        $parameters = json_decode($request->getContent(), true);

        $product->setName($parameters['name']);
        $product->setPrice($parameters['price']);
        $entityManager->flush();

        $data = [
            'id' => $product->getId(),
            'name' => $product->getName(),
            'price' => $product->getPrice(),
        ];

        return $this->json($data);
    }

    #[Route('/product/{id}', name: 'product_delete', methods: ['DELETE'])]
    public function delete(ManagerRegistry $doctrine, int $id): Response
    {
        $entityManager = $doctrine->getManager();
        $product = $entityManager->getRepository(Product::class)->find($id);

        if (!$product) {
            return $this->json('No product found for id' . $id, 404);
        }

        $entityManager->remove($product);
        $entityManager->flush();

        return $this->json('Deleted a product successfully with id ' . $id);
    }
}
