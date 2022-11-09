# "Discover" module

Module that is shown after the start of the application.

## To set up

There is no need for special set up for this module.

This module is opened at the start of the application that is described in [AppCoordinator](https://github.com/iCookbook/Cookbook/blob/master/Cookbook/Application/AppCoordinator.swift) 

## Dependencies

This module has 4 dependencies:

- `CommonUI` for some reasons:
    * Image loader in `UIImageView`
    * Access to `UIButton`'s creators
- `Resources` for access to resources of the application
- `Models` to use `Recipe` model
- `Networking` to fetch recipes from the server
- `RecipeDetails` to open this module after user tapps on a recipe.

## Screenshots
