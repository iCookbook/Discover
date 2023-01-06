# "Discover" module

Module that is shown after the start of the application.

## To set up

There is no need for special set up for this module.

This module is opened at the start of the application that is described in [AppCoordinator](https://github.com/iCookbook/Cookbook/blob/master/Cookbook/Application/AppCoordinator.swift) 

## Dependencies

This module has 4 dependencies:

- [CommonUI](https://github.com/iCookbook/CommonUI) for some reasons:
    * Image loader in `UIImageView`
    * Access to `UIButton`'s creators
- [Resources](https://github.com/iCookbook/Resources) for access to resources of the application
- [Models](https://github.com/iCookbook/Models) to use `Recipe` model
- [Networking](https://github.com/iCookbook/Networking) to fetch recipes from the server
- [RecipeDetails](https://github.com/iCookbook/RecipeDetails) to open this module after user tapps on a recipe.

## Screenshots

---

For more details, read [GitHub Wiki](https://github.com/iCookbook/Discover/wiki) documentation
