# Swiftly_Project

iOS Project for Swiftly

## Overview

This is a simple iOS project to show a proof of concept for a dynamic UICollectionView that will display dummy product data.
The project is build with Swift and Storyboard files. This project has a deployment target of iOS 13.2 and requires Xcode >=11.
It is recommended that this project be run on the iPhone 11 Pro Max simulator.

## Build and Run Project

- Using git, clone the project to a machine that has Xcode installed.
- Open the `.xcodeproj` file.
- Build the project with `cmd+b`.
- Select the desired simulator from the drop down next to the Target selection bar.
- Press the "Play" button in the upper left of Xcode.

## Project Architecture

The majority of the UI functionality is handled in the `ManagerSpecialViewController.swift`. This is where the dynamic sizing
is handled for the `ManagerSpecialCollectionViewCell.swift`. The UICollectionViewDataSource, UICollectionViewDelegate, and
UICollectionViewDelegateFlowLayout methods are especially important for sizing and configuring cells.

The request to fetch data from the server is handled in the `NetworkController.swift`. This function converts the data to
JSON and returns either the JSON data or an error via a completion handler.

This project is set up with a Core Data stack to allow data to be shown even if the Networking fails. All of the Core Data
actions are contained in the `CoreDataController.swift` file. Some of the methods in this file are not used but were included
to demonstrate what would be needed in an enterprise application.
