const products = [
    {id: 1, name: 'Laptop', categoryId: 1, price: 2000},
    {id: 2, name: 'Smartphone', categoryId: 1, price: 1000},
    {id: 3, name: 'Headphones', categoryId: 1, price: 200},
    {id: 4, name: 'T-Shirt', categoryId: 2, price: 30},
    {id: 5, name: 'Jeans', categoryId: 2, price: 50},
    {id: 6, name: 'Dress', categoryId: 2, price: 80},
    {id: 7, name: 'Cushion', categoryId: 3, price: 20},
    {id: 19, name: 'Hat', categoryId: 2, price: 20},
    {id: 20, name: 'Belt', categoryId: 2, price: 20},
    {id: 21, name: 'Dress', categoryId: 2, price: 20},
    {id: 8, name: 'Vase', categoryId: 3, price: 40},
    {id: 9, name: 'Wall Art', categoryId: 3, price: 50},
    {id: 10, name: 'Lipstick', categoryId: 4, price: 15},
    {id: 11, name: 'Perfume', categoryId: 4, price: 50},
    {id: 12, name: 'Face Mask', categoryId: 4, price: 10},
    {id: 13, name: 'Football', categoryId: 5, price: 30},
    {id: 14, name: 'Yoga Mat', categoryId: 5, price: 25},
    {id: 15, name: 'Dumbbells', categoryId: 5, price: 50},
    {id: 16, name: 'Novel', categoryId: 6, price: 20},
    {id: 17, name: 'Self-Help Book', categoryId: 6, price: 15},
    {id: 18, name: 'Cookbook', categoryId: 6, price: 25},
];

const getProducts = (categoryId) => {
    return products.filter(
        (product) => product.categoryId === categoryId
    );
};

export {
    getProducts
}