# Separation of Concerns & Single Responsibility

## Separation of Concerns (SoC)

### What?
Components that have different role or purpose are kept separately with weak coupling with other components / services allowing minimal extension / upgrade / maintenance work.

### How?
Identify skillsets, tools and technologies to evaluate the isolation and identify means of communication and translation with other components.

### Who?
* TCP/IP
* MVC. The framework separates Presentation, Business Logic & Data.
* Web FrontEnd - HTML, CSS, JavaScript


## Why?
* Development / Test Relieve
* Reusability
* Less overhead in packaging and deployment
* Isolated Debugging / Fixing
* Ease of infra software patches and upgrades


## Single Responsibility

### What?
A Service / Component / Class having a single objective to achieve. When there is a business reason to change, The impact is isolated to the relevant module and does not impact other functions.

### How?
Identify use case and expected result. The servicing object should only have a single public function to achieve the objective. having a mindset of KISS and YAGNI will help.

### Who?
Single Responsibility Principle (SOLID)
Open/Close Principle (SOLID)

## Why?
* Focused on completing a single objectve (Dev/Test)
* Faster delivery of a feature
* Easily extendable without impacting other areas of the software
* Easy rollback to the previous version of the function
* Easy retirement of the previous version of the function
* Isolated Debugging / Fixing

## Demo

### Use case
As a customer i would like to create a product on the site so that users will be able to search and view my product.

In order th achieve this, we need:
1. The ability for the system to authenticate and authorize the user to perform the
required actions.
2. A UI for the user to add product information and save it into the database
3. Validation the information provided by the user before creating a product
4. Creating a product
5. Product appears in the relevant results.
6. Product and it's details can be viewed by the user.

> Note: for demo purposes we will only cover item 3, 4 & 5


### The Codebase.

Open and view the content of `Eg.Product.psm1`.

#### Part 1: The Monolith
Open the `part01-monolith` folder and observe the contents of the module
Notice that all the functions are in a single file.
This is a dinasour that is ready to go extinct. It's Big, clunky and unfogiving.

#### Part 2: Identify Concerns
The code needs to handle multiple concerns in a single function. This can be easily separated by grouping the concerns. For example, the validation, creation and indexing.
Open the `part02-concerns` folder and observe the separation

#### Part 3: Single responsibility function preparation
Open the `part03-functions` folder.
Observe that each function is responsible to handle 1 concern. Do also take note that this gives us opportunity to refactor and change function or variable names to keep the code relevant and maintain visibility.

#### Part 4: Modularizing
Open the `part04-modular` folder.
Notice that now we have multiple module that are independant. This allows the feature to be loosely coupled the the modules to be reusable.

* `Eg.Product.psm1` - The service interface that is exposed to the consuming services.
* `Eg.Product.Validation.psm1` - The Validation Module that other internal services can consume.
* `Eg.Product.Create.psm1` - The Product creation module.
* `Eg.Product.Indexing.psm1` - The Product Indexing module.

#### Part 5: Modularizing with Microserviceing in mind
Open the `part04-modular` folder.
From the already modularized components, we can further create modules for each functions. This is applicable for the validation module. Again we will change the validation module name (refactor) for relevancy and visibility.

* `Eg.Product.Validation..psm1` changed to `Eg.Validation.Product.psm1.`
* `Eg.Validation.Product.Details.psm1`
* `Eg.Validation.Product.Image.psm1`
* `Eg.Validation.Product.Prices.psm1`
* `Eg.Validation.Product.Stock.psm1`
* `Eg.Validation.Product.Campaign.psm1`


