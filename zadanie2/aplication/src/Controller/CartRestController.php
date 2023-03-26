<?php

namespace App\Controller;

use App\Entity\Cart;
use Doctrine\Persistence\ManagerRegistry;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

#[Route('/api', name: 'api_')]
class CartRestController extends AbstractController
{

    #[Route('/cart', name: 'cart_index', methods: ['GET'])]
    public function index(ManagerRegistry $doctrine): Response
    {
        $carts = $doctrine
            ->getRepository(Cart::class)
            ->findAll();

        $data = [];

        foreach ($carts as $cart) {
            $data[] = [
                'id' => $cart->getId(),
                'amount' => $cart->getAmount(),
                'comment' => $cart->getComment(),
            ];
        }

        return $this->json($data);
    }

    #[Route('/cart', name: 'cart_new', methods: ['POST'])]
    public function new(ManagerRegistry $doctrine, Request $request): Response
    {

        $entityManager = $doctrine->getManager();
        $parameters = json_decode($request->getContent(), true);

        $cart = new Cart();
        $cart->setAmount($parameters['amount']);
        $cart->setComment($parameters['comment']);

        $entityManager->persist($cart);
        $entityManager->flush();

        return $this->json($cart);
    }

    #[Route('/cart/{id}', name: 'cart_show', methods: ['GET'])]
    public function show(ManagerRegistry $doctrine, int $id): Response
    {
        $cart = $doctrine->getRepository(Cart::class)->find($id);

        if (!$cart) {
            return $this->json('No cart found for id' . $id, 404);
        }

        $data = [
            'id' => $cart->getId(),
            'amount' => $cart->getAmount(),
            'comment' => $cart->getComment(),
        ];

        return $this->json($data);
    }

    #[Route('/cart/{id}', name: 'cart_edit', methods: ['PUT'])]
    public function edit(ManagerRegistry $doctrine, Request $request, int $id): Response
    {
        $entityManager = $doctrine->getManager();
        $cart = $entityManager->getRepository(Cart::class)->find($id);

        if (!$cart) {
            return $this->json('No cart found for id' . $id, 404);
        }

        $parameters = json_decode($request->getContent(), true);

        $cart->setAmount($parameters['amount']);
        $cart->setComment($parameters['comment']);
        $entityManager->flush();

        $data = [
            'id' => $cart->getId(),
            'amount' => $cart->getAmount(),
            'comment' => $cart->getComment(),
        ];

        return $this->json($data);
    }

    #[Route('/cart/{id}', name: 'cart_delete', methods: ['DELETE'])]
    public function delete(ManagerRegistry $doctrine, int $id): Response
    {
        $entityManager = $doctrine->getManager();
        $cart = $entityManager->getRepository(Cart::class)->find($id);

        if (!$cart) {
            return $this->json('No cart found for id' . $id, 404);
        }

        $entityManager->remove($cart);
        $entityManager->flush();

        return $this->json('Deleted a cart successfully with id ' . $id);
    }
}
